def decoder_m_to_n(m, n):
  for i in range(n):
    binario = bin(i)[2:].zfill(m)
    linha = f"assign OUT[{i}] = EN"
    for j in range(m):
      complemento = "" if binario[j] == "1" else "~" 
      linha += f" & {complemento}IN[{m-1-j}]"
    print(linha+";")