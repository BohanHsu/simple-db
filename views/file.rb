def handle_multi_string(interpeter, input)
  commands = input.split(/\n/)
  results = commands.map do |command|
    interpeter.string_to_action(command)
  end.select do |result|
    !result.nil?
  end

  results.each do |result|
    puts result
  end
end
