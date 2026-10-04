#!/usr/bin/env python3
# MIDI -> Sonic Pi tables, printed to stdout: mid2sonicpi.py song.mid > song.rb
# One table per track: [notes, beats to next event, length in beats],
# notes = MIDI number or chord array, :r = leading rest.

import re
import sys

import mido


def notes_of(track, tpb):
	# (start beat, length beats, pitch); a retriggered pitch closes the old one
	now, held, out = 0, {}, []
	for m in track:
		now += m.time
		if m.type not in ("note_on", "note_off"):
			continue
		key = (m.channel, m.note)
		if key in held:
			start = held.pop(key)
			out.append((start / tpb, (now - start) / tpb, m.note))
		if m.type == "note_on" and m.velocity > 0:
			held[key] = now
	return sorted(out)


def events(notes):
	by_onset = {}
	for start, length, pitch in notes:
		by_onset.setdefault(start, []).append((pitch, length))
	onsets = sorted(by_onset)
	out = []
	if onsets and onsets[0] > 0:
		out.append(f"[:r,{onsets[0]:g},0]")
	for i, t in enumerate(onsets):
		group = by_onset[t]
		ps = sorted({p for p, _ in group})
		length = max(l for _, l in group)
		nxt = onsets[i + 1] - t if i + 1 < len(onsets) else length
		ns = ps[0] if len(ps) == 1 else "[" + ",".join(map(str, ps)) + "]"
		out.append(f"[{ns},{nxt:g},{length:.3g}]")
	return out


def const_name(raw, taken):
	# Ruby constants: uppercase start, word chars only, unique
	base = re.sub(r"\W+", "_", raw.strip("\x00 ")).strip("_").upper()
	if not base[:1].isalpha():
		base = "TRACK_" + base
	name, n = base, 2
	while name in taken:
		name, n = f"{base}_{n}", n + 1
	taken.add(name)
	return name


mid = mido.MidiFile(sys.argv[1])
tempos = [m.tempo for t in mid.tracks for m in t if m.type == "set_tempo"]
sigs = [m for t in mid.tracks for m in t if m.type == "time_signature"]
if len(set(tempos)) > 1:
	print(f"warning: {len(set(tempos))} tempos, using the first",
		file=sys.stderr)
bpm = round(mido.tempo2bpm(tempos[0]), 2) if tempos else 120
bar = sigs[0].numerator * 4 / sigs[0].denominator if sigs else 4

print(f"# from {sys.argv[1]}\n# [notes, beats to next event, length]")
print(f"BPM = {bpm}\nBAR_BEATS = {bar:g}")
taken = set()
for i, track in enumerate(mid.tracks):
	evs = events(notes_of(track, mid.ticks_per_beat))
	if not evs:
		continue
	rows = [",".join(evs[j:j + 8]) for j in range(0, len(evs), 8)]
	name = const_name(track.name or str(i), taken)
	print(f"\n{name} = [\n\t" + ",\n\t".join(rows) + "]")
