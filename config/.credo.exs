%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/**", "test/**"],
        excluded: []
      },
      checks: [
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 80}
      ]
    }
  ]
}
