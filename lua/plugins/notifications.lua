-- Enhanced notification system with easy error copying
return {
  -- Helper commands for error management
  {
    "folke/noice.nvim",
    config = function()
      -- Add these commands after Noice is loaded
      vim.api.nvim_create_user_command("CopyErrors", function()
        local messages = require("noice").api.get_messages()
        if #messages == 0 then
          vim.notify("No messages to copy", vim.log.levels.INFO)
          return
        end
        
        local error_text = {}
        for _, msg in ipairs(messages) do
          if msg.level == "error" or msg.kind == "error" then
            table.insert(error_text, msg.content)
          end
        end
        
        if #error_text == 0 then
          -- Copy all messages if no errors
          for _, msg in ipairs(messages) do
            table.insert(error_text, msg.content)
          end
        end
        
        local text = table.concat(error_text, "\n")
        vim.fn.setreg("+", text)
        vim.notify("Errors copied to clipboard", vim.log.levels.INFO)
      end, { desc = "Copy error messages to clipboard" })
      
      -- Debug commands
      vim.api.nvim_create_user_command("DebugInfo", function()
        print("Noice loaded:", pcall(require, "noice"))
        print("Notify loaded:", pcall(require, "notify"))
        local ok, noice = pcall(require, "noice")
        if ok then
          print("Noice version:", vim.inspect(noice.version or "unknown"))
        end
      end, { desc = "Show debug info" })
      
      vim.api.nvim_create_user_command("DebugErrors", function()
        local ok, messages = pcall(function()
          return require("noice").api.get_messages()
        end)
        if ok then
          print("Messages count:", #messages)
          for i, msg in ipairs(messages) do
            print(string.format("%d: %s", i, vim.inspect(msg)))
          end
        else
          print("Failed to get messages:", messages)
        end
      end, { desc = "Debug error messages" })
      
      vim.api.nvim_create_user_command("DebugPlugins", function()
        print("Loaded plugins:")
        for name, _ in pairs(package.loaded) do
          if name:match("^noice") or name:match("^notify") then
            print(" -", name)
          end
        end
      end, { desc = "Debug loaded plugins" })
    end,
  },
}