defmodule Population do
  defstruct size: 100, chromossomes: []

  def generate_population(size \\ 100) do
    population = %Population{size: size}

    chromossomes =
      1..size
      |> Enum.map(fn _ -> Chromossome.generate_chromossome() end)

    population = %{population | chromossomes: chromossomes}
    population
  end
end
