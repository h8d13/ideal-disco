# Shostakovich - Waltz No. 2 (Jazz Suite)
# From Andrea Tam's piano transcription, C minor, 3/4, q = 170.
# Part 1: bars 1-39. 
# Part 2: bars 40-143. SKIP
# Part 3: bars 144-219 (low theme, climax, ending).
# Entries: [notes, beats, length]; length < 1 = staccato, :r = rest.

use_bpm 170

S = 0.25
CM3 = [:c3, :eb3, :g3]
CM4 = [:c4, :eb4, :g4]
EG = [:eb3, :g3]

define :oom do |low, upper|
  [[low, 1], [upper, 1], [upper, 1]]
end

define :stac do |low, upper|
  [[low, 1, S], [upper, 1, S], [:r, 1]]
end

# shift every note of a part by semis, rests untouched
define :transpose_part do |part, semis|
  part.map do |ns, b, frac|
    moved = if ns == :r then :r
    elsif ns.is_a?(Array) then ns.map { |x| note(x) + semis }
    else note(ns) + semis
    end
    [moved, b, frac].compact
  end
end

VAMP = [[:r, 1], [CM3, 1], [CM3, 1]]

THEME = [
[:g4, 3],					# 5
[:eb4, 2], [:d4, 1],
[:c4, 4], [:c4, 1], [:d4, 1],			# 7-8 (tie)
[:eb4, 1], [:c4, 1], [:eb4, 1],
[:g4, 2], [:ab4, 1],				# 10
[:g4, 3],
[:f4, 3],
[:f4, 3],
[:d4, 2], [:c4, 1],
[:b3, 4], [:g3, 1], [:b3, 1],			# 15-16 (tie)
[:d4, 1], [:b3, 1], [:d4, 1],
[:f4, 1], [:g4, 1], [:ab4, 1],
[:fs4, 3],
[:g4, 3]]					# 20

# top line of the chorded repeat (bars 21-27)
THEME_HI = [[:c5, 3], [:d5, 2], [:c5, 1], [:bb4, 2], [:ab4, 1], [:ab4, 3],
[:d5, 3], [:c5, 2], [:bb4, 1], [:bb4, 3]]

CHORUS = [
[[:eb4, :g4, :c5], 3],				# 21
[[:eb4, :g4, :d5], 2], [[:eb4, :g4, :c5], 1],
[[:c4, :f4, :bb4], 2], [[:c4, :f4, :ab4], 1],
[[:c4, :f4, :ab4], 3],
[[:f4, :ab4, :d5], 3],				# 25
[[:d4, :f4, :c5], 2], [[:d4, :f4, :bb4], 1],
[[:eb4, :g4, :bb4], 3]]

# staccato section (bars 28-38)
PICKUP = [[:r, 1], [[:c5, :eb5], 1, S], [[:d5, :f5], 1, S]]
UP = [[[:eb5, :g5], 1, S], [[:eb5, :g5], 0.5, S], [[:d5, :f5], 0.5, S],
[[:eb5, :g5], 0.5, S], [[:f5, :ab5], 0.5, S]]
DOWN = [[[:d5, :f5], 1, S], [[:d5, :f5], 0.5, S], [[:c5, :eb5], 0.5, S],
[[:d5, :f5], 0.5, S], [[:eb5, :g5], 0.5, S]]
LAND = [[[:c5, :eb5], 1, S], [:r, 1], [[:c5, :eb5, :g5], 1, S]]
CLIMB = [
[:r, 1], [[:ab5, :c6], 1, S], [[:b5, :d6], 1, S],
[[:c6, :eb6], 1, S], [[:c6, :eb6], 0.5, S], [[:b5, :d6], 0.5, S],
[[:c6, :eb6], 0.5, S], [[:d6, :f6], 0.5, S],
[[:b5, :d6], 1, S], [[:b5, :d6], 0.5, S], [[:ab5, :c6], 0.5, S],
[[:b5, :d6], 0.5, S], [[:c6, :eb6], 0.5, S]]
STACC = (PICKUP + UP + DOWN + LAND) * 2 + CLIMB
STACC_END = [[[:c5, :eb5, :g5, :c6], 1, S], [:r, 2]]

RH = VAMP * 4 + THEME + CHORUS + STACC + STACC_END +	# 1-39
[[:r, 1], [CM4, 1], [CM4, 1]] * 4 +		# 144-147
transpose_part(THEME, -12) +			# 148-163
CHORUS + STACC + STACC_END +			# 164-182
[[:r, 1], [[:g2, :b2, :d3, :f3], 3]] +		# 183 fermata
transpose_part(THEME, 12) +			# 184-199
transpose_part(CHORUS, 12) +			# 200-206
STACC +						# 207-217
[[[:c5, :eb5, :g5], 1, S], [:r, 1], [[:b4, :f5, :g5], 1, 0.5],
[[:c5, :eb5, :g5], 1, 0.5], [:r, 2]]		# 218-219

LO_C = [:c2, :c3]
LO_D = [:d2, :d3]
LO_G = [:g1, :g2]
LO_AB = [:ab2, :ab3]
MID_G = [:g2, :g3]

STACC_LH = [[LO_AB, 1, S], [:r, 2]] + stac(MID_G, EG) +
stac(LO_AB, [:d3, :f3]) + stac(MID_G, EG) +	# 28-31
stac(LO_AB, [:c3, :eb3]) + stac(MID_G, EG) +
stac(LO_AB, [:d3, :f3]) + stac(MID_G, EG) +	# 32-35
[[LO_AB, 1, S], [:r, 2]] + stac(MID_G, EG) +
stac(MID_G, [:f3, :g3])				# 36-38

CU = [:g3, :c4, :eb4]
FU = [:ab3, :c4, :f4]
GU = [:g3, :d4, :f4]

# low-theme accompaniment (bars 148-163, reused at 184-199)
LOW_LH = (oom(LO_C, CU) + oom(LO_G, CU)) * 3 +
(oom(LO_D, FU) + oom(LO_G, FU)) * 2 +
(oom(LO_D, GU) + oom(LO_G, GU)) * 2 +
oom(LO_C, CU) + oom(LO_G, CU)

# chorded-repeat accompaniment (bars 164-170, reused at 200-206)
CHORUS_LH = oom(LO_C, CU) + oom(LO_C, [:eb3, :g3, :c4]) +
oom(:f2, [:ab3, :c4, :d4]) * 2 +
oom([:bb1, :bb2], [:ab3, :bb3, :d4]) * 2 +
oom([:eb2, :eb3], [:g3, :bb3, :eb4])

LH = [[LO_C, 1], [:r, 2], [LO_G, 1], [:r, 2]] * 2 +
oom(:c3, EG) + oom(:g2, EG) + oom(:c3, EG) + oom(:g2, EG) +
oom(:c3, EG) + oom(:g2, EG) +			# 5-10
oom(:d3, [:f3, :ab3, :c4]) + oom(:g2, [:f3, :ab3, :c4]) +
oom(:d3, [:f3, :ab3, :c4]) + oom(:g2, [:f3, :ab3]) +
oom(:d3, [:f3, :g3]) + oom(:g2, [:f3, :g3]) +	# 11-16
oom(:d3, [:f3, :g3]) + oom(:g2, [:f3, :g3, :b3]) +
oom(:c3, EG) + oom(:g2, [:eb3, :g3, :c4]) +
oom(:c3, [:eb3, :g3, :c4]) + oom(:g2, [:eb3, :g3, :c4]) +
oom(:f2, [:ab3, :d4]) + oom(:f2, [:ab3, :d4]) +	# 17-24
oom(:bb2, [:d3, :ab3, :bb3]) + oom(:bb2, [:d3, :ab3, :bb3]) +
oom(:eb3, [:g3, :bb3]) +			# 25-27
STACC_LH + oom(LO_C, EG) +			# 28-39
[[LO_C, 3], [LO_G, 3]] * 2 +			# 144-147
LOW_LH + CHORUS_LH +				# 148-170
STACC_LH + oom(LO_C, EG) + [[LO_G, 4]] +	# 171-183
LOW_LH + CHORUS_LH +				# 184-206
STACC_LH +					# 207-217
[[LO_C, 1, S], [:r, 1], [LO_G, 1, 0.5], [LO_C, 1, 0.5], [:r, 2]]

# sustained harmony under the high theme (bars 184-199)
PAD = [[[:eb4, :g4, :c5], 18], [[:f4, :ab4, :c5], 12],
[[:f4, :g4, :b4, :d5], 12], [[:eb4, :g4, :c5], 6]]

define :perform do |part, vol|
  use_synth :piano
  part.each do |ns, b, frac|
    frac ||= 0.9
    play ns, sustain: b * frac, release: 0.3, amp: vol
    sleep b
  end
end

# sax-ish lead: blade with delayed vibrato, soft attack, legato
define :sax do |part, cut, vol|
  use_synth :blade
  part.each do |n, b|
    play n, attack: 0.08, sustain: b * 0.8, release: 0.25,
    cutoff: cut, amp: vol, vibrato_rate: 5.5,
    vibrato_depth: 0.12, vibrato_delay: 0.25, vibrato_onset: 0.2
    sleep b
  end
end

with_fx :reverb, room: 0.5, mix: 0.3 do
  in_thread do
    perform RH, 1.0
  end
  in_thread do
    sleep 12					# enters at bar 5
    sax THEME + THEME_HI, 95, 0.8			# 5-27
    sleep 48					# 28-39, 144-147
    sax transpose_part(THEME, -12), 78, 1.2	# 148-163, low sax
    sax THEME_HI, 95, 0.8				# 164-170
    sleep 40					# 171-183
    sax THEME + THEME_HI, 100, 0.9			# 184-206
  end
  in_thread do
    sleep 238					# bar 184 (incl. fermata beat)
    perform PAD, 0.5
  end
  perform LH, 0.7
end
