--[[
--
--

return {
  'liljaylj/codestats.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = { 'TextChanged', 'InsertEnter' },
  cmd = { 'CodeStatsXpSend', 'CodeStatsProfileUpdate' },
  config = function()
    require('codestats').setup {
      username = 'f-person',
      base_url = 'https://codestats.net',
      api_key = '<your API key>',
      send_on_exit = true,  -- send xp on nvim exit
      send_on_timer = true,  -- send xp on timer
      timer_interval = 30000,  -- timer interval in milliseconds (minimum 1000ms to prevent DDoSing codestat.net servers)
      curl_timeout = 5,  -- curl request timeout in seconds
    }
  end,
}

--
--
--]]

return {}
