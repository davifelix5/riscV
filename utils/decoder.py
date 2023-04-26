for i in range(1, 32):
  binario = bin(i)[2:].zfill(5)
  complementos = ["~" if binario[i] == "0" else "" for i in range(5)]
  linha = f"assign OUT[{i}] = EN"
  for j in range(5):
    complemento = "" if binario[j] == "1" else "~" 
    linha += f" & {complemento}IN[{4-j}]"
  print(linha+";")