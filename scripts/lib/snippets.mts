/** VS Code snippet bodies expanded with their default values, so LuaLS can check them. */

export interface Snippet {
  prefix: string;
  description: string;
  body: string[];
}

/** Index of the `}` that closes the `{` before `start`, skipping nested placeholders. */
function closing(text: string, start: number): number {
  let depth = 1;

  for (let index = start; index < text.length; index++) {
    if (text[index] === "\\") index++;
    else if (text[index] === "{") depth++;
    else if (text[index] === "}" && --depth === 0) return index;
  }

  throw new Error(`Unclosed placeholder in: ${text}`);
}

/**
 * Replaces tabstops with their defaults: `${1:x}` becomes `x`, `${1|a,b|}` becomes `a`,
 * `$1`, `${1}` and `$0` become nothing.
 */
export function expand(text: string): string {
  let result = "";
  let index = 0;

  while (index < text.length) {
    const char = text[index] as string;

    if (char === "\\" && index + 1 < text.length) {
      result += text[index + 1];
      index += 2;
      continue;
    }

    if (char !== "$") {
      result += char;
      index++;
      continue;
    }

    const plain = /^\$(\d+)/.exec(text.slice(index));

    if (plain) {
      index += plain[0].length;
      continue;
    }

    if (text[index + 1] !== "{") {
      throw new Error(`Snippet variables are not supported: ${text.slice(index, index + 20)}`);
    }

    const end = closing(text, index + 2);
    const inner = text.slice(index + 2, end);
    const choice = /^\d+\|([^,|]*)/.exec(inner);
    const placeholder = /^\d+:([\s\S]*)$/.exec(inner);

    if (choice) result += choice[1];
    else if (placeholder) result += expand(placeholder[1] as string);
    else if (!/^\d+$/.test(inner)) throw new Error(`Unknown placeholder: \${${inner}}`);

    index = end + 1;
  }

  return result;
}

/** A snippet as Lua code: tabs as four spaces, every tabstop at its default. */
export function toLua(snippet: Snippet): string {
  return expand(snippet.body.join("\n")).replace(/\t/g, "    ");
}
