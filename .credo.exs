%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: []
      },
      checks: [
        # I'm not sure I like this rule
        {Credo.Check.Readability.PreferImplicitTry, false},
      ]
    }
  ]
}