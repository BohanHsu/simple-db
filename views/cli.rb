def cmdline(interpreter)
  shutdown = false
  while !shutdown do
    command = gets
    #p input
    if command.upcase =~ /END/
      shutdown = true
    else
      result = interpreter.string_to_action(command)
      puts result if !result.nil?
    end
  end
end
