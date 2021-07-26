# 34+10 porcí
# 2 porce bez masa vedle
using JSON

# počet ĺidí a konstanta žravosti, kterou se vynásobí veškeré suroviny
n = 40
zravost = 1.05

jid = JSON.parsefile("jidelnicekTabor/jidelnicek.json")
ing = Any[]

# objekty "kolik" se rozdělí podle "ks" a "kg" a naskládají do ingrediencí ing
for den in [29:31;1:7]
    global ing
    q = split(jid[string(den)]["vecere"]["kolik"],"+")
    s = Array{Any}(undef,length(q))

    for i in 1:length(q)    
        if occursin(" kg ", q[i])
            spl = split.(q[i],"kg")
        elseif occursin(" ks ", q[i])
            spl = split.(q[i],"ks")
        else
            print("\n problém ve dni "+den)
        end
        s[i] = [lstrip(rstrip(spl[2])),parse(Float64,spl[1])]
    end
    append!(ing,copy(s))
end

# seřazení, sečtení ingrediencí a vynásobení počtem lidí
sort!(ing)
list = Any[]

for i in 1:length(ing)-1
    co = ing[i][1]
    kolik = ing[i][2]
    a = kolik
    if co==ing[i+1][1]
        a += ing[i+1][2]
    else
        push!(list,[co,a*zravost*n])
    end
end

list