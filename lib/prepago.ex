defmodule Prepago do

  @preco_minuto 1.45

  defstruct creditos: 10, recargas: []

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= 10 -> {:ok, "A chamada custou #{custo}"}
      true -> {:error, "Você não tem créditos para fazer a ligação, faça uma recarga"}
    end
  end
end
