import { encoding_for_model } from "tiktoken";

const text = "Robot teachers have been secretly placed in schools.";
console.log("Text original: ", text);

// Inițializează encodingul specific modelului text-embedding-ada-002
const enc = encoding_for_model("text-embedding-ada-002");

// Tokenizează textul → array de token ID-uri (Uint32Array)
const tokenIds = enc.encode(text);

// Decodează fiecare token ID înapoi în șirul de bytes corespunzător
const tokens = Array.from(tokenIds).map((id) => {
  const bytes = enc.decode(new Uint32Array([id]));
  return new TextDecoder().decode(bytes);
});

console.log("Text original:    ", text);
console.log("Număr de tokeni:  ", tokenIds.length);
console.log("Token IDs:        ", Array.from(tokenIds));
console.log("Tokeni (text):    ", tokens);

// Eliberează memoria alocată de WebAssembly
enc.free();