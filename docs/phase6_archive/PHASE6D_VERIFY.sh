#!/bin/bash
# Phase 6D Pre-Flight Verification Script
# Run this BEFORE starting Phase 6D to verify everything exists

echo "=== Phase 6D Pre-Flight Checks ==="
echo

# 1. Check agent files (4 with -context suffix, 1 without)
echo "1. Checking agent files..."
for agent in forge-context deployment-context docgen-context hardware-debug-context; do
  if [ -f ".claude/agents/${agent}/agent.md" ]; then
    echo "   ✅ ${agent}"
  else
    echo "   ❌ ${agent} (MISSING!)"
  fi
done

# workflow-coordinator doesn't have -context suffix
if [ -f ".claude/agents/workflow-coordinator/agent.md" ]; then
  echo "   ✅ workflow-coordinator"
else
  echo "   ❌ workflow-coordinator (MISSING!)"
fi
echo

# 2. Check package contract
echo "2. Checking package contract..."
if [ -f ".claude/shared/package_contract.md" ]; then
  echo "   ✅ package_contract.md"
else
  echo "   ❌ package_contract.md (MISSING!)"
fi
echo

# 3. Check templates
echo "3. Checking Jinja2 templates..."
if [ -d "forge/templates" ]; then
  for tpl in shim.vhd.j2 main.vhd.j2; do
    if [ -f "forge/templates/$tpl" ]; then
      echo "   ✅ $tpl"
    else
      echo "   ❌ $tpl (MISSING!)"
    fi
  done
else
  echo "   ❌ forge/templates/ directory missing!"
fi
echo

# 4. Check Python imports (requires venv)
echo "4. Checking Python API availability..."
if command -v uv &> /dev/null; then
  uv run python -c "
try:
    from forge.generator.codegen import load_yaml_spec, create_register_package, prepare_template_context
    print('   ✅ forge.generator.codegen imports')
except ImportError as e:
    print(f'   ❌ forge.generator.codegen: {e}')

try:
    from basic_app_datatypes import RegisterMapper
    print('   ✅ basic_app_datatypes.RegisterMapper')
except ImportError as e:
    print(f'   ❌ basic_app_datatypes: {e}')
" 2>/dev/null || echo "   ⚠️  uv run failed (try: cd to project root)"
else
  echo "   ⚠️  uv not found, skipping Python import checks"
fi
echo

# 5. Check existing architecture docs (from Phase A)
echo "5. Checking existing architecture docs..."
if [ -f "docs/architecture/submodule_integration.md" ]; then
  echo "   ✅ submodule_integration.md (from Phase A)"
else
  echo "   ❌ submodule_integration.md (should exist from Phase A!)"
fi
echo

# 6. Summary
echo "=== Summary ==="
all_good=true
[ ! -f ".claude/agents/forge-context/agent.md" ] && all_good=false
[ ! -f ".claude/agents/workflow-coordinator/agent.md" ] && all_good=false
[ ! -f ".claude/shared/package_contract.md" ] && all_good=false
[ ! -f "forge/templates/shim.vhd.j2" ] && all_good=false
[ ! -f "forge/templates/main.vhd.j2" ] && all_good=false

if $all_good; then
  echo "✅ All critical files exist - READY for Phase 6D!"
else
  echo "❌ Some files missing - DO NOT START Phase 6D until fixed!"
fi
echo
echo "Run from project root: cd /Users/johnycsh/moku-instrument-forge && ./docs/PHASE6D_VERIFY.sh"
