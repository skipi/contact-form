defmodule ContactForm.Crypto do
  require Logger

  def hash(param) do
    :crypto.hash(:md5, param) |> Base.encode16()
  end

  def check_hash(binary_param, string_param) do
    binary_param == Base.encode16(:crypto.hash(:md5, string_param))
  end
end
