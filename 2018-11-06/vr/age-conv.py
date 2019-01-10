# extract header line and data lines from original xls
with open("age-orig.tsv") as i:
    with open("age.tsv","w") as o:
        n = 2
        o.write(i.readline())
        for l in i:
            if n%3 == 0:
                o.write(l)
            n += 1
