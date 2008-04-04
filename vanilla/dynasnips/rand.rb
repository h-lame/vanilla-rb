require 'vanilla/dynasnip'

class RandomNumber < Dynasnip
  snip_name "rand"
  
  usage %|
    Returns a random number, normally between 1 and 100. 
    The range can be limited:
    
    {rand 50} renders a random number between 1 and 50
    {rand 2,19} renders a random number between 2 and 19
  |
  
  def handle(*args)
    min = 1
    max = 100
    max = args[0] if args.length == 1
    if args.length == 2
      min = args[0]
      max = args[1]
    end
    # arguments come in as strings, so we need to convert them.
    min = min.to_i
    max = max.to_i
    (rand(max-min) + min)
  end
end