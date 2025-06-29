const Database = require("better-sqlite3");
const path = require("path");

const db = new Database("~/file_index.db"); // expand manually if needed

function getFilesByTag(tagName) {
  const query = `
    SELECT f.path
    FROM file f
    JOIN file_tag_junction ftj ON f.id = ftj.file_id
    JOIN tag t ON ftj.tag_id = t.id
    WHERE t.name = ?
    ORDER BY f.path ASC;
  `;
  return db.prepare(query).all(tagName);
}

function buildTree(paths) {
  const root = {};

  for (const { path: fullPath } of paths) {
    const parts = fullPath.split("/").filter(Boolean); // skip empty from leading /
    let node = root;

    for (const part of parts) {
      if (!node[part]) node[part] = {};
      node = node[part];
    }
  }

  return root;
}

function printTree(node, indent = "") {
  for (const key of Object.keys(node)) {
    console.log(indent + "└── " + key);
    printTree(node[key], indent + "    ");
  }
}

// === USAGE EXAMPLE ===
const files = getFilesByTag("Books");
const tree = buildTree(files);
printTree(tree);
