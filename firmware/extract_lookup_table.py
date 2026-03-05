import os
import sys

FIRMWARE_FILE = "Keyboard_Upgrade_0x20.bin"
OUTPUT_FILE = os.path.join("src", "protocol_encoding_table.h")

SIGNATURE = b'\xE8\x39\x10\xBD'
TABLE_SIZE = 128

# find the table
if not os.path.exists(FIRMWARE_FILE):
    print(f"Error: File '{FIRMWARE_FILE}' not found. Take it from /vendor/etc/ and place in the same directory as this script")
    sys.exit(1)

print(f"Reading file: {FIRMWARE_FILE}...")
with open(FIRMWARE_FILE, "rb") as f:
    firmware_data = f.read()

offset = firmware_data.find(SIGNATURE)

# read the table
if offset != -1:
    print(f"Found at offset={hex(offset)}")

    extracted_table = firmware_data[offset : offset + TABLE_SIZE]

    if len(extracted_table) != TABLE_SIZE:
        print("Error: Unexpected EOF, cannot read 128 bytes.")
        sys.exit(1)

    rows = []
else:
    print("Error: can't find the lookup table")
    sys.exit(1)

# generate the header
for i in range(8):
    chunk = extracted_bytes[i*16 : (i+1)*16]
    hex_strings = [f"0x{b:02X}" for b in chunk]
    row_str = "  {" + ", ".join(hex_strings) + "}"
    rows.append(row_str)

table_content = ",\n".join(rows)

table_header = f"""#ifndef PROTOCOL_ENCODING_H
#define PROTOCOL_ENCODING_H

const uint8_t LOOKUP_TABLE[8][16] = {{
{table_content}
}};

#endif
"""

with open(OUTPUT_FILE, "w", encoding="utf-8") as out_f:
    out_f.write(table_header)

print(f"Success! Generated '{OUTPUT_FILE}'.")
