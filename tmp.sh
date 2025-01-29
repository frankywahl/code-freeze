curl \
	-X PUT \
	-H "Accept: application/vnd.github+json" \
	-H "Authorization: Bearer ${GITHUB_TOKEN}" \
	-H "X-GitHub-Api-Version: 2022-11-28" \
	"https://api.github.com/repos/frankywahl/code-freeze/rulesets/2493528" \
	-d '{"enforcement": "disabled"}'

