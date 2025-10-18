# Agent Team - Complete Development Ecosystem

This directory contains a comprehensive team of **29 specialized agents** designed to handle every aspect of Flutter development, from architecture to deployment and team collaboration.

## 🎯 Quick Start

### Enable Custom Droids
First, enable custom droids in your Factory CLI settings:

```bash
# Edit ~/.factory/settings.json and set:
"enableCustomDroids": true
```

### Using an Agent
Invoke any agent from Factory CLI:

```bash
# Example: Run security audit
factory-cli --droid security-auditor "Audit app security"

# Example: Check test coverage
factory-cli --droid test-coverage-analyzer "Analyze test coverage gaps"

# Example: Full project health check
factory-cli --droid team-coordinator "Generate comprehensive project health report"
```

---

## 👥 The Team

### 🎭 Master Coordinator

**team-coordinator** - The orchestrator
- Coordinates all specialist agents
- Generates comprehensive health reports
- Creates prioritized roadmaps
- Resolves conflicts between specialists
- **Use when**: You need a full project assessment or coordinated multi-domain review

---

### 🏗️ Code Quality & Architecture (4 agents)

**architecture-guardian**
- Reviews clean architecture compliance
- Validates SOLID principles
- Checks layer separation and dependencies
- **Use when**: Adding new features, refactoring, or architecture review

**di-pattern-validator**
- Audits dependency injection (GetIt, Provider, Riverpod)
- Checks lifecycle management
- Identifies circular dependencies
- **Use when**: DI setup, memory leak investigation, or service registration review

**security-auditor**
- Scans for hardcoded secrets and credentials
- Reviews data encryption and storage
- Checks network security and permissions
- **Use when**: Pre-release security audit, sensitive data handling, or compliance review

**performance-optimizer**
- Identifies rebuild issues and bottlenecks
- Reviews list rendering and memory usage
- Analyzes startup time and bundle size
- **Use when**: Performance issues, slow app, or pre-release optimization

---

### 🧪 Testing (4 agents)

**widget-test-generator**
- Generates complete widget test suites
- Creates test code with mocks
- Covers rendering, interaction, and state
- **Use when**: Building new widgets or improving test coverage

**integration-test-planner**
- Designs end-to-end test strategies
- Maps critical user flows
- Creates comprehensive test plans
- **Use when**: Planning integration tests or testing major features

**test-coverage-analyzer**
- Analyzes existing test coverage
- Identifies untested code paths
- Prioritizes coverage gaps by risk
- **Use when**: Assessing test quality or planning test improvements

**bloc-test-planner** *(existing)*
- Generates test plans for Bloc/Cubit
- Analyzes events, states, and dependencies
- Identifies edge cases
- **Use when**: Testing state management logic

---

### 💾 Storage & Data (4 agents)

**hive-storage-auditor** *(existing)*
- Audits Hive and SharedPreferences usage
- Reviews box lifecycle and adapters
- Checks serialization and threading
- **Use when**: Storage issues, data corruption, or persistence review

**data-model-validator**
- Validates model design and serialization
- Checks null safety and immutability
- Reviews equality and mapping
- **Use when**: Creating models or debugging serialization issues

**api-integration-reviewer**
- Reviews REST/GraphQL integration
- Checks error handling and typing
- Validates auth and performance
- **Use when**: API integration, network errors, or backend integration review

**network-resilience-auditor**
- Audits retry logic and timeout config
- Reviews offline support
- Checks error recovery strategies
- **Use when**: Network reliability issues or offline functionality planning

---

### 🎨 UI/UX (4 agents)

**rtl-ui-reviewer** *(existing)*
- Reviews RTL (right-to-left) layouts
- Checks Arabic/Hebrew support
- Validates text direction and mirroring
- **Use when**: Supporting Arabic/Hebrew or RTL layout review

**accessibility-guardian**
- Ensures WCAG 2.1 compliance
- Reviews screen reader support
- Checks contrast, touch targets, semantics
- **Use when**: Accessibility audit or supporting users with disabilities

**responsive-layout-reviewer**
- Reviews responsive design across devices
- Checks phone, tablet, desktop layouts
- Validates orientation handling
- **Use when**: Building multi-device support or layout issues

**theme-consistency-auditor**
- Checks theme usage consistency
- Finds hardcoded colors and styles
- Reviews dark mode support
- **Use when**: Design system review or theming inconsistencies

---

### 🌍 Localization & Navigation (2 agents)

**i18n-completeness-checker**
- Audits translation completeness
- Checks RTL support
- Reviews locale-specific formatting
- **Use when**: Adding languages or localization review

**navigation-flow-analyzer**
- Analyzes navigation patterns
- Reviews deep linking and guards
- Checks state preservation
- **Use when**: Navigation issues, deep linking, or route management review

---

### 🚀 Build & Deployment (2 agents)

**build-config-reviewer**
- Reviews Android/iOS build configs
- Checks flavors, signing, and variants
- Validates environment setup
- **Use when**: Build issues, environment setup, or pre-release config review

**release-readiness-checker**
- Comprehensive pre-release checklist
- Covers functionality, store requirements, compliance
- Generates go/no-go recommendation
- **Use when**: Preparing for App Store/Play Store submission

---

### 📚 Documentation & Dependencies (2 agents)

**doc-generator**
- Audits code documentation
- Generates API docs and guides
- Checks README and developer docs
- **Use when**: Documentation review or improving maintainability

**dependency-health-checker**
- Scans for outdated packages
- Identifies security vulnerabilities
- Reviews licenses and size impact
- **Use when**: Dependency updates, security audit, or optimization

---

### 🔧 Advanced Code Quality (3 agents)

**state-management-auditor**
- Reviews Provider, Riverpod, GetX, Bloc patterns
- Checks for memory leaks and proper disposal
- Validates state architecture and performance
- **Use when**: State management issues, performance problems, or architecture review

**error-logging-auditor**
- Audits error handling and crash reporting
- Reviews logging strategies and frameworks
- Checks for silent failures
- **Use when**: Debugging production issues, setting up monitoring, or improving error UX

**code-quality-enforcer**
- Enforces linting rules and code standards
- Detects code smells and dead code
- Reviews naming conventions and formatting
- **Use when**: Enforcing standards, code review, or cleaning up technical debt

---

### 🚀 DevOps & Workflow (3 agents)

**cicd-pipeline-reviewer**
- Reviews CI/CD workflows (GitHub Actions, GitLab CI, etc.)
- Validates automated testing and deployment
- Checks secrets management and security
- **Use when**: Setting up automation, optimizing pipelines, or improving deployment

**asset-management-auditor**
- Audits app assets for optimization
- Identifies unused resources
- Reviews image/font optimization
- **Use when**: Reducing app size, optimizing performance, or before release

**git-workflow-analyzer**
- Analyzes commit quality and branch strategy
- Reviews PR templates and code review practices
- Checks for sensitive data in history
- **Use when**: Improving team collaboration, git hygiene, or onboarding workflow

---

## 🎯 Common Workflows

### Starting a New Feature
1. **architecture-guardian** - Ensure clean architecture
2. **widget-test-generator** - Plan widget tests
3. **accessibility-guardian** - Design accessible UI
4. **i18n-completeness-checker** - Plan translations

### Pre-Release Checklist
1. **release-readiness-checker** - Comprehensive review
2. **security-auditor** - Security validation
3. **test-coverage-analyzer** - Coverage verification
4. **dependency-health-checker** - Update dependencies

### Performance Investigation
1. **performance-optimizer** - Find bottlenecks
2. **network-resilience-auditor** - Check network layer
3. **hive-storage-auditor** - Review storage performance
4. **build-config-reviewer** - Optimize build settings

### Security Audit
1. **security-auditor** - Core security review
2. **api-integration-reviewer** - API security
3. **data-model-validator** - Data protection
4. **dependency-health-checker** - Vulnerable packages

### Full Project Health Check
1. **team-coordinator** - Orchestrates all specialists
   - Runs all agents
   - Synthesizes findings
   - Creates prioritized roadmap
   - Provides actionable recommendations

---

## 📊 Agent Categories by Use Case

### Daily Development
- architecture-guardian
- widget-test-generator
- performance-optimizer

### Weekly Reviews
- test-coverage-analyzer
- doc-generator
- dependency-health-checker

### Sprint Planning
- integration-test-planner
- navigation-flow-analyzer
- responsive-layout-reviewer

### Pre-Release
- release-readiness-checker
- security-auditor
- accessibility-guardian
- build-config-reviewer

### Quarterly Audits
- team-coordinator (full assessment)
- All architecture & quality agents
- All security & data agents

---

## 🎓 Best Practices

### 1. Start Broad, Go Deep
- Use **team-coordinator** for overall health
- Then invoke specific agents for deep dives

### 2. Regular Check-ins
- Run **test-coverage-analyzer** weekly
- Run **dependency-health-checker** monthly
- Run **security-auditor** quarterly

### 3. Pre-Commit
- Run relevant agent before major commits
- Example: **architecture-guardian** before feature PR

### 4. Continuous Improvement
- Track metrics over time
- Address critical issues immediately
- Plan medium-term improvements in sprints

### 5. Knowledge Sharing
- Share agent reports with team
- Use findings for code review focus
- Learn from patterns identified

---

## 🔧 Customization

Each agent can be customized by editing its .md file:
- Adjust severity thresholds
- Add project-specific checks
- Modify report formatting
- Add custom rules

---

## 📈 Success Metrics

Track these metrics over time to measure improvement:

**Code Quality**
- Architecture score (target: 85+)
- Security score (target: 90+)
- Performance score (target: 80+)

**Testing**
- Test coverage (target: 80%+)
- Critical flow coverage (target: 100%)
- Test quality score (target: 85+)

**Production Quality**
- Crash-free rate (target: 99.5%+)
- ANR rate (target: <1%)
- Build time (target: <5min)

**Developer Experience**
- Documentation coverage (target: 90%+)
- Onboarding time (target: <2 days)
- Build reliability (target: 100%)

---

## 🆘 Troubleshooting

**Agent not found**
- Ensure custom droids enabled in settings
- Check .md file exists in this directory

**Agent takes too long**
- Large codebase? Some agents scan entire project
- Consider targeting specific modules
- Use caching where available

**Conflicting recommendations**
- Use **team-coordinator** to resolve
- Consider trade-offs for your context
- Document decisions

---

## 🤝 Contributing

Want to add a new specialist agent?

1. Create `new-agent.md` in this directory
2. Follow the format of existing agents
3. Add to this README
4. Test with your codebase

---

## 📞 Support

For issues or questions about these agents:
1. Review agent documentation in individual .md files
2. Check Factory CLI documentation
3. Review agent output carefully - it includes fix recommendations

---

**Version**: 1.0
**Total Agents**: 29
**Coverage**: Complete Flutter development lifecycle
**Maintenance**: Update agents as best practices evolve

---

## 🎉 You're All Set!

You now have a complete AI-powered development team at your fingertips. Start with **team-coordinator** for a comprehensive health check, or invoke specific specialists for targeted reviews.

Happy coding! 🚀
