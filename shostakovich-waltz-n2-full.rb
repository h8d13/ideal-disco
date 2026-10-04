use_bpm 170

# bars where the sax doubles the melody, with its octave shift
SAX_BARS = {
	(5..27) => 0,			# first theme
	(145..168) => -24,		# recap: low sax
}
# melody octave shift for the piano (follows the low recap)
SHIFTS = {
	(145..168) => -24,
}
# bouncy eighth-note sections: played short
STACC_BARS = [(28..38), (66..76), (169..179)]

define :bar_at do |t|
	(t / 3).floor + 1
end

define :lookup do |table, t|
	hit = table.find { |range, _| range.include?(bar_at(t)) }
	hit && hit[1]
end

define :moved do |ns, semis|
	if ns == :r then :r
	elsif ns.is_a?(Array) then ns.map { |x| x + semis }
	else ns + semis
	end
end

define :staccato_at do |t|
	STACC_BARS.any? { |range| range.include?(bar_at(t)) }
end

define :piano_melody do |part, vol|
	use_synth :piano
	t = 0
	part.each do |ns, b, len|
		ns = moved(ns, lookup(SHIFTS, t) || 0)
		hold = staccato_at(t) ? 0.25 : len * 0.9
		play ns, sustain: hold, release: 0.3, amp: vol
		sleep b
		t += b
	end
end

# oom-pah: bass on the downbeat gets an octave below, chords short
define :piano_accomp do |part, vol|
	use_synth :piano
	t = 0
	part.each do |ns, b, len|
		downbeat = (t % 3).zero? && ns.is_a?(Integer)
		ns = [ns - 12, ns] if downbeat
		hold = staccato_at(t) ? 0.25 : len * 0.9
		play ns, sustain: hold, release: 0.3, amp: downbeat ? vol : vol * 0.7
		sleep b
		t += b
	end
end

# sax-ish lead: blade with delayed vibrato, only inside SAX_BARS
define :sax do |part|
	use_synth :blade
	t = 0
	part.each do |ns, b, len|
		semis = lookup(SAX_BARS, t)
		if semis
			low = semis < 0
			play moved(ns, semis), attack: 0.08, sustain: len * 0.8,
				release: 0.25, cutoff: low ? 78 : 95,
				amp: low ? 1.2 : 0.8, vibrato_rate: 5.5,
				vibrato_depth: 0.12, vibrato_delay: 0.25,
				vibrato_onset: 0.2
		end
		sleep b
		t += b
	end
end

with_fx :reverb, room: 0.5, mix: 0.3 do
	in_thread do
		sax MELODY
	end
	in_thread do
		piano_melody MELODY, 1.0
	end
	piano_accomp ACCOMP, 0.8
end
