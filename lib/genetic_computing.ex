defmodule GeneticComputing do
  alias Population
  def run do
    pop = Population.generate_population(50)

    IO.puts("Best initial fitness #{Population.best_chromossome(pop).fitness}")

    pop = Population.evolute(pop, 100_000)

    IO.puts("Best fitness after mutations #{Population.best_chromossome(pop).fitness}")
  end
end
