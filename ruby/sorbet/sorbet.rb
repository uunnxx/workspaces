# typed: strong

# require 'sorbet-runtime'

# class A
#   extend T::Sig

#   sig {params(x: Integer).returns(String)}
#   def bar(x)
#     x.to_s
#   end
# end

# sig {returns(String)}
# def main
#   A.new.barr(91)    # error: Typo!
#   A.new.bar("91")   # error: Type mismatch!
# end


# (1) add this to get access to sig method
extend T::Sig

# (2) add a signature
sig {params(env: T::Hash[Symbol, Integer], key: Symbol).void}
def log_env(env, key)
  puts "LOG: #{key} => #{env[key]}"
end

log_env({ timeout_len: 2000 }, 'timeout_len') # Expected 'Symbol' but found String("timeout_len")

