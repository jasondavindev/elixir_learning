defmodule Gene do
  defstruct [:id, weight: 1]

  def generate_gene do
    %Gene{
      id: round(:rand.uniform() * 100_000),
      weight: :rand.uniform() * 200
    }
  end
end
