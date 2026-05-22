
use('sample_mflix');

db.embedded_movies.createSearchIndex({
  name: "PlotSemanticIndex",
  type: "vectorSearch",
  definition: {
    fields: [
      {
        type: "vector",
        path: "plot_embedding",
        numDimensions: 1536,
        similarity: "cosine"
      },
      { "type": "filter",  "path": "title" }
    ]
  }
})