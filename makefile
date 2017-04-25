# Initialize makefile_dir before any include directives
abspath_to_makefile := $(abspath $(lastword ${MAKEFILE_LIST}))
makefile_dir := $(patsubst %/,%,$(dir ${abspath_to_makefile}))

SHELL := /bin/bash

.PHONY: all
all: play

title := kick_demo
wav_file := ${makefile_dir}/${title}.wav

.PHONY: play
play: ${wav_file}
	sndfile-play "${wav_file}"

instruments := $(wildcard ${makefile_dir}/instruments/*)
opcodes := $(wildcard ${makefile_dir}/opcodes/*)
orchestra := ${makefile_dir}/orchestra
parts := $(wildcard ${makefile_dir}/parts/*)
score := ${makefile_dir}/score

csound_flags := -b 256 -B 1024 --dither -m 135 -s

sampling_rate := 44100

${wav_file}: ${instruments} ${opcodes} ${orchestra} ${parts} ${score}
	csound ${csound_flags} -W -o temp "${orchestra}" "${score}"; \
	trap 'rm -f temp' EXIT; \
	sndfile-resample -to "${sampling_rate}" -c 0 temp "${wav_file}"

.PHONY: clean
clean:
	rm -f "${wav_file}"
