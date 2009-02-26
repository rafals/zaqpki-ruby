files = {}
readlines.each do |line|
  begin
    action = line[/#[\t ]*([a-z ]*):[\t ]*(.*)/, 1].to_sym
    file_name = line[/#[\t ]*([a-z ]*):[\t ]*(.*)/, 2]
    files[action] ||= []
    files[action] << file_name
  rescue
  end
end
output = []
files.each do |type, files_list|
  output << type.to_s + ": "+ files_list.join(", ")
end
puts output.join(" | ")