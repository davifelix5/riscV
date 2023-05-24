def to_binary(decimal_number: int, amount_of_bits: int) -> str:
  return bin(decimal_number)[2:].zfill(amount_of_bits)


def get_instruction(bin_opcode : str, inst_type: str, imm: int=0, rs1: int=0, rs2: int=0, rd: int=0, funct3: str='', funct7: str=''):
  bin_rs1 = to_binary(rs1, 5)
  bin_rs2 = to_binary(rs2, 5)
  bin_rd = to_binary(rd, 5)
  if inst_type == 'J':
    bin_imm = to_binary(imm, 21)
    return f'{bin_imm[20-20]}{bin_imm[20-10:20-0]}{bin_imm[20-11]}{bin_imm[20-19:20-11]}{bin_rd}{bin_opcode}'
  if inst_type == 'I':
    bin_imm = to_binary(imm, 12)
    return f'{bin_imm}{bin_rs1}{funct3}{bin_rd}{bin_opcode}'


if __name__ == '__main__':
  print(get_instruction(imm=233*4, rd=1, bin_opcode='1101111', inst_type='J'))
  print(get_instruction(imm=8, rs1=0, rd=0, bin_opcode='1100111', inst_type='I', funct3='000'))