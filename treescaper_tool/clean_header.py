import sys

def run(f_name, o_name):
    in_body = False
    with open(o_name, 'w') as o:
        with open(f_name) as f:
            for line in f.readlines():
                if in_body:
                    o.write(line)
                if '>' in line:
                    in_body = True

if __name__ == "__main__":
    run(sys.argv[1], sys.argv[2])