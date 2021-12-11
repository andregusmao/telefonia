defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  setup do
    File.write(@assinantes[:prepago], :erlang.term_to_binary([]))
    File.write(@assinantes[:pospago], :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm(@assinantes[:prepago])
      File.rm(@assinantes[:pospago])
    end)
  end

  describe "Funções de ligaçãoo" do
    test "fazer uma ligação" do
      Assinante.cadastrar("André", "123", "456", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) == {:ok, "A chamada custou 4.35"}
    end
  end

end
