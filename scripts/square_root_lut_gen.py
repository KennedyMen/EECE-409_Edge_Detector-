import math

def populate_lut(path: str):
  with open(path, "w") as file:
      for i in range(2033):
          root = math.sqrt(i * 1024)
          int_root = round(root)
          file.write(f"{int_root}, ")

def populate_lut_2(path: str):
  with open(path, "w") as file:
      for i in range(1024):
          root = math.sqrt(i)
          int_root = round(root)
          file.write(f"{int_root}, ")

populate_lut("./square_root_lut_values.txt")
populate_lut_2("./square_root_lut_values_small.txt")


