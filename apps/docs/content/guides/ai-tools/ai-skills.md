---
title: Agent Skills
---

* Agent Skills
  * == folders of 
    * instructions
    * scripts
  * allows
    * agents can discover & use to do things 
      * MORE accurately
      * MORE efficiently
  * uses
    * extend agents' capabilities

## how to install skills?

* -- through -- [skills npm package](https://github.com/vercel-labs/skills)

```bash
# install ALL Supabase skills | your project
npx skills add supabase/agent-skills

# install a specific skill | your project
npx skills add supabase/agent-skills --skill SKILL_NAME

# install ALL Supabase skills | ALL your Supabase projects
npx skills add supabase/agent-skills --global

# install ALL Supabase skills | ALL detected agents
npx skills add supabase/agent-skills --all

# MORE options
## https://github.com/vercel-labs/skills
```

* if you want to install the agent skills + Supabase MCP server -> use the [Supabase Plugin -- for -- AI Coding Agents](plugins)

## Available skills

* [here](https://github.com/supabase/agent-skills/tree/main/skills)

## how to find MORE skills?

* ways
  * check | https://skills.sh
  * `npx skills find QUERY`

## MORE

* [Supabase Agent Skills Repository](https://github.com/supabase/agent-skills)
* [Agent Skills Documentation](https://agentskills.io/home)
* [Agent Skills Overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
* [skills npm package](https://github.com/vercel-labs/skills)
