defmodule Telefonia do
  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def start do
    File.write(@assinantes[:prepago], :erlang.term_to_binary([]))
    File.write(@assinantes[:pospago], :erlang.term_to_binary([]))
  end

  def cadastrar_assinante(nome, numero, cpf, plano \\ :prepago) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end
end
