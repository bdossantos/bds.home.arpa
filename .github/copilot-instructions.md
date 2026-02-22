# GitHub Copilot Instructions

## Commit Messages

Always use [Conventional Commits](https://www.conventionalcommits.org/) format for commit messages:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc.)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `build`: Changes that affect the build system or external dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files
- `revert`: Reverts a previous commit

### Examples

```
feat(homeassistant): add new automation for lights
fix(docker): correct base image version
docs: update README with setup instructions
ci: update GitHub Actions workflow
chore(deps): bump dependencies
```
