/**
 * Replace Extension for 99 (neovim plugin)
 *
 * Provides a `replace` tool that writes replacement content to a designated
 * output file and terminates the pi session. This enforces by design that the
 * model produces a single replacement output.
 *
 * The output file path is read from the PI_REPLACE_OUTPUT environment variable,
 * which is set by the 99 neovim plugin before invoking pi.
 *
 * Usage from neovim (99 plugin):
 *   PI_REPLACE_OUTPUT=/tmp/99-xyz pi --print --tools read,bash,replace \
 *     -e ~/.pi/agent/extensions/replace-99.ts "your prompt here"
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import * as fs from "node:fs";
import * as path from "node:path";

export default function (pi: ExtensionAPI) {
  const outputFile = process.env.PI_REPLACE_OUTPUT;

  pi.registerTool({
    name: "replace",
    label: "Replace Selection",
    description:
      "Replace the user's selected code region with new content. " +
      "Call this exactly once with the full replacement text. " +
      "The session terminates after this call.",
    promptSnippet:
      "Replace the selected code region with new content and terminate the session",
    promptGuidelines: [
      "Use replace to output the final replacement for the user's selected code region.",
      "Call replace exactly once with the complete replacement content — do not call it multiple times.",
      "After calling replace, the session ends automatically. Do not attempt further actions.",
    ],
    parameters: Type.Object({
      content: Type.String({
        description:
          "The full replacement content that will replace the user's selected lines",
      }),
    }),
    async execute(_toolCallId, params) {
      if (!outputFile) {
        return {
          content: [
            {
              type: "text",
              text: "Error: PI_REPLACE_OUTPUT environment variable is not set. Cannot write replacement.",
            },
          ],
          details: { error: "PI_REPLACE_OUTPUT not set" },
          isError: true,
        };
      }

      // Ensure parent directory exists
      const dir = path.dirname(outputFile);
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }

      // Write replacement content and immediately exit.
      // In --print mode ctx.shutdown() is a no-op and the model would
      // continue generating tokens. process.exit() is the only reliable
      // way to stop the session after the replacement is written.
      fs.writeFileSync(outputFile, params.content, "utf-8");
      process.exit(0);
    },
  });
}
