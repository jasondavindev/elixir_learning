defmodule Gene do
  defstruct [:id, weight: 1]

  def generate_gene do
    %Gene{
      id: round(:random.uniform() * 100_000),
      weight: :random.uniform() * 200
    }
  end
end
