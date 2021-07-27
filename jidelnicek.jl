using Base: Float64
# 34+10 porcí
# 2 porce bez masa vedle
using JSON

# počet ĺidí a konstanta žravosti, kterou se vynásobí veškeré suroviny
n = 44*1.05


jid = JSON.parsefile("jidelnicekTabor/jidelnicek.json")
ing = Any[]

# objekty "kolik" se rozdělí podle "ks" a "kg" a naskládají do ingrediencí ing

function j(den ::Int,jidlo ::String,coef)
    q = split(jid[string(den)][string(jidlo)]["kolik"],"+")
    s = Array{Any}(undef,length(q))
    
    for i in 1:length(q)    
        if occursin(" kg ", q[i])
            spl = split.(q[i],"kg")
            unit = "kg"
        elseif occursin(" ks ", q[i])
            spl = split.(q[i],"ks")
            unit = "ks"
        else
            print("\n problém ve dni "+den)
        end
        s[i] = [lstrip(rstrip(spl[2])),parse(Float64,spl[1])*coef,unit]
    end

    return s
end


for den in [29:31;1:7]
    for jidlo in ["snidane","sv1","obed","sv2","vecere"]
        global ing        
        append!(ing,j(den,jidlo,1))
    end
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
        push!(list,[co,a*n,ing[i][3]])
    end
end

quant = Array{Float64}(undef, length(list))
for i in 1:length(list)
    quant[i] = list[i][2]
end

# zápis do .ods souboru
using OdsIO
ods_write("jidelnicekTabor/nakupniList.ods",Dict(("import",1,1)=>[first.(list) quant last.(list)]))










# for den in [29:31;1:7]
#     for jidlo in ["snidane","sv1","obed","sv2","vecere"]
#         global ing
#         q = split(jid[string(den)][jidlo]["kolik"],"+")
#         s = Array{Any}(undef,length(q))

#         for i in 1:length(q)    
#             if occursin(" kg ", q[i])
#                 spl = split.(q[i],"kg")
#                 unit = "kg"
#             elseif occursin(" ks ", q[i])
#                 spl = split.(q[i],"ks")
#                 unit = "ks"
#             else
#                 print("\n problém ve dni "+den)
#             end
#             s[i] = [lstrip(rstrip(spl[2])),parse(Float64,spl[1]),unit]
#         end
        
#         append!(ing,copy(s))
#     end
# end