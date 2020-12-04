defmodule GeneticComputing do
  alias Population

  def run do
    pop = Population.generate_population(100)

    IO.puts("Best initial fitness #{Population.best_chromossome(pop).fitness}")
    num_schedulers = :erlang.system_info(:schedulers_online)
    parallel_evolution = Population.evolute(pop, 100_000, num_schedulers, :parallel)
    IO.puts("Time spent: #{parallel_evolution.spent_time}")

    IO.puts(
      "Best fitness after mutations #{
        Population.best_chromossome(parallel_evolution.population).fitness
      }"
    )
  end
end
