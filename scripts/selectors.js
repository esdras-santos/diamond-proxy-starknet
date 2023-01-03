function getSelectors(compiledContract) {
  const entryPoints = compiledContract.entry_points_by_type
  let selectors = []
  // Iterate over all the functions in the contract ABI
  for (const func of entryPoints.EXTERNAL) {
    selectors.push(func.selector)
  }  
  return selectors
}

exports.getSelectors = getSelectors