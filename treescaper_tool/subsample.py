import random
import sys

"""
    Will subsample an input file by line.
    python subsample.py file.txt 1000 
    Will sample 1000 lines randomly

    python subsample.py file.txt 1000 interval
    Will sample 1000 lines spaced # of lines / 1000 intervals apart

"""


def random_subsample(file_name, sample_size):
    with open(file_name) as f:
        read_lines = f.readlines()

    if len(read_lines) < sample_size:
        print(
            "ERROR: Sample size of %s and file line count %s"
            % (sample_size, len(read_lines))
        )
        sys.exit(1)

    rnd_lines = random.sample(range(0, len(read_lines)), sample_size)
    rnd_lines.sort()
    with open("subsampled.file", "w") as f_out:
        for l in rnd_lines:
            f_out.write(read_lines[l])


def random_subsample_interval(file_name, sample_size):
    with open(file_name) as f:
        read_lines = f.readlines()

    if len(read_lines) < sample_size:
        print(
            "ERROR: Sample size of %s and file line count %s"
            % (sample_size, len(read_lines))
        )
        sys.exit(1)

    intervals = 0
    step = len(read_lines) / sample_size
    tail = 0
    head = step

    with open("subsampled.file", "w") as f_out:

        while head < len(read_lines):
            r = random.sample(range(tail, head), 1)
            f_out.write(read_lines[r[0]])
            tail = head
            head = head + step
            intervals += 1
        if intervals < sample_size:
            r = random.sample(range(tail, head), 1)
            f_out.write(read_lines[r[0]])


if __name__ == "__main__":
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print("ERROR: incorrect argument list %s" % sys.argv)
        sys.exit(1)
    if len(sys.argv) == 3:
        random_subsample(sys.argv[1], int(sys.argv[2]))
    else:
        random_subsample_interval(sys.argv[1], int(sys.argv[2]))
