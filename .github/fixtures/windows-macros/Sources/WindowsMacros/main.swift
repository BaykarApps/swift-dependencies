import Dependencies

let live = Reader().summary
let overridden = withDependencies {
  $0.numberClient.next = { 7 }
  $0.greeting = "override"
} operation: {
  Reader().summary
}

print("live: \(live)")
print("overridden: \(overridden)")
precondition(live == "42 live", "Unexpected live values")
precondition(overridden == "7 override", "Unexpected overridden values")
