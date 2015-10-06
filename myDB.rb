require './views/cli'
require './views/file'
require './controllers/database'
require './controllers/interpreter'

def main
  @database = Database.new
  @interpreter = Interpreter.new(@database)
  
  input_file = !STDIN.tty?
  
  if input_file
    input = $stdin.read
    handle_multi_string(@interpreter, input)
  else
    cmdline(@interpreter)
  end
end

main
