#params: infile, outfile

require 'securerandom'

def coord_to_scalar(r, c)
  65536 * r + c
end


tile_id = {
  "." => 0,
  "F" => 1,
  "S" => 1,
  "M" => 0,
  "O" => 2,
  " " => 1,
}

entities = {
  "M" => 2,
  "S" => 3,
  "F" => 4,
}

z_index = {
  "M": 1
}

z_index.default = 0

level_data = File.open(ARGV[0]).readlines.map{|x| x.chomp}
title = level_data.shift
level_data.unshift "OOOOOOOOOOOOOOOOOO"
level_data << "OOOOOOOOOOOOOOOOOO"
level_data.map!{|row| "O" + row + "O"}
tile_output = "tile_data = PoolIntArray( "
entity_output = ""
level_data.each_with_index do |row, r|
  row.each_char.with_index do |cell, c|
    unless tile_id.include? cell
      raise "unrecognized ID '#{cell}' at r#{r} c#{c}"
    end
    tile_output << "#{coord_to_scalar(r,c)}, #{tile_id[cell]}, 0, "
    if entities.key? cell
      entity_output << %Q|[node name="#{SecureRandom.uuid}" parent="." instance=ExtResource( #{entities[cell]} )]\nposition = Vector2( #{24 * c + 12}, #{24 * r + 12} )\nz_index = #{z_index[cell]}\n\n|
    end
  end
end
tile_output.chomp!(", ")
tile_output << " )\n\n"

output = File.read("res/level_header.txt")
output << "\n" << tile_output << entity_output
File.open(ARGV[1], 'w'){|outfile| outfile.write output}