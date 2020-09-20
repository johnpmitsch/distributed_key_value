FILE_LOCATION = 'store'.freeze
MAP = {}.freeze

# REPL utilities to access distributed store
class DREPL
  def handle_input(input)
    result = parse_command(input)
    puts(" 🖨️  #{result}")
  end

  private

  def read_mapping
    bmap = File.read(FILE_LOCATION)
    Marshal.load(bmap)
  end

  def persist_mapping
    File.write(FILE_LOCATION, Marshal.dump(MAP))
  end

  def set(inputs)
    if inputs[0]
      input = inputs[0]
      if input.include? '='
        values = input.split('=')
        if values.length == 2
          MAP[values[0].to_sym] = values[1]
          persist_mapping
          'Value set succesfully'
        else
          "Invalid input value for set command, please pass a key and value, i.e. 'set foo=bar'"
        end
      else
        "Invalid input value for set command, please use the format 'key=value', i.e. 'set foo=bar'"
      end
    else
      "Set command invalid, please pass a value. i.e. 'set foo=bar'"
    end
  end

  def get(inputs)
    if inputs[0]
      key = inputs[0]
      map = read_mapping
      value = map[key.to_sym]
      return value if value

      "#{key} not found!"
    else
      "Get command invalid, please pass a value. i.e. 'get foo'"
    end
  end

  def parse_command(input)
    parsed = input.split(' ')
    instruction = parsed.shift
    case instruction
    when 'set'
      set(parsed)
    when 'get'
      get(parsed)
    else
      "Command #{instruction} not found"
    end
  end
end
