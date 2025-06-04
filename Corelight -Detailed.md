I am a **Cybersecurity Analyst: Expert in network security assessments, skilled in authoring detailed, actionable vulnerability reports.**

**Corelight Appliance Configuration: Security Vulnerability Analysis and Remediation Report**

**1.0 Executive Summary**

* **Purpose:** This report details the findings of a security assessment conducted on a Corelight appliance, based on user configuration settings provided in the document 'Corelight.pdf'.1 The primary objective is to identify security vulnerabilities arising from these configurations and to recommend actionable remediation steps to enhance the appliance's security posture.  
* **Key Findings Overview:** The review of the Corelight appliance's configuration has revealed several critical and high-severity vulnerabilities. Prominent among these are the complete disablement of Two-Factor Authentication (2FA) for the administrative user and globally 1, the allowance of an outdated cryptographic protocol (TLS 1.1) 1, the absence of enforced password policies for complexity and expiration 1, and the disabled state of Common Criteria Mode.1 Further weaknesses include disabled brute-force prevention and the lack of automatic logout for idle user sessions.1 This constellation of disabled security features indicates a significantly weakened security posture, rendering the appliance more susceptible to a variety of attack vectors. These are not merely isolated misconfigurations but represent a pattern of lax security practices.  
* **Overall Risk Assessment:** Based on the number and severity of the identified vulnerabilities, the overall risk to the Corelight appliance in its current configuration is assessed as **High**. The potential for unauthorized access, data compromise, and system control by malicious actors is substantial.  
* **Call to Action:** It is imperative that the vulnerabilities detailed in this report are addressed with urgency. Implementing the recommended remediation measures is crucial for protecting the Corelight appliance, the sensitive data it processes, and the network segments it is designed to monitor and secure.

**2.0 Introduction**

* **Background:** This security vulnerability analysis is the result of a meticulous review of the Corelight appliance's configuration settings, as documented in the 'Corelight.pdf' file.1 The Corelight appliance is a critical component in network security monitoring, and its proper configuration is paramount to its effectiveness and the overall security of the monitored environment.  
* **Methodology:** The assessment involved analyzing the provided configuration screenshots 1 against established cybersecurity best practices, industry standards, and relevant security guidelines. Particular attention was given to authentication mechanisms, session management, password policies, cryptographic protocols, and specialized security modes such as Common Criteria Mode, referencing available documentation on its principles and implications.2  
* **Scope and Limitations:** This report is strictly limited to the vulnerabilities identifiable from the configuration settings presented in the 'Corelight.pdf' document.1 It does not cover potential vulnerabilities that may exist due to outdated firmware or software versions (which were not visible in the provided data), underlying operating system vulnerabilities, network segmentation issues, physical security of the appliance, or other security aspects not discernible from the supplied configuration details.  
* **Report Structure:** The report begins with this introduction, followed by a detailed breakdown of each identified vulnerability, including its description, potential impact, and recommended remediation steps. A summary table of vulnerabilities is provided for a quick overview. The report concludes with a summary of key recommendations and next steps for improving the appliance's security posture.

**3.0 Detailed Vulnerability Findings**

This section provides a comprehensive analysis of each security vulnerability identified from the Corelight appliance's configuration settings.1 Each finding includes a description of the vulnerability, an assessment of its potential impact on the appliance and the organization, and specific, actionable remediation steps.

* **Table: Vulnerability Summary**

| Vulnerability ID | Vulnerability Title | Brief Description | Assessed Impact Level | Key Remediation Action |
| :---- | :---- | :---- | :---- | :---- |
| VULN-001 | Brute-Force Prevention Disabled | The mechanism to prevent or slow down automated password guessing attacks is not active. | High | Enable and configure brute-force prevention with appropriate thresholds. |
| VULN-002 | Inadequate User Session Management | Idle user sessions are not automatically terminated, increasing risk from unattended consoles. | Medium | Enable auto-logout for idle user sessions with a suitable timeout period. |
| VULN-003 | Lack of Default Password Change Enforcement | Users are not forced to change default or administrator-set passwords upon first login. | High | Enable the prompt for users to change default passwords. |
| VULN-004 | Disabled 2FA for 'admin' User (Web UI & SSH) | The primary administrative account lacks mandatory two-factor authentication for all access methods. | Critical | Enable and enforce 2FA for the 'admin' user for both web UI and SSH access. |
| VULN-005 | Disabled Global Two-Factor Authentication (2FA) | 2FA is not enforced globally for all users, leading to potential inconsistencies in security. | High | Enable global 2FA enforcement for all user accounts. |
| VULN-006 | Unenforced Password Policies | No system-enforced rules for password complexity (length, character types) or expiration. | High | Enable and configure strong password complexity and expiration policies. |
| VULN-007 | Common Criteria Mode Disabled | The appliance is not operating under an enhanced security configuration standard (Common Criteria). | Medium | Evaluate and consider enabling Common Criteria Mode after assessing operational impact. |
| VULN-008 | Use of Outdated Cryptographic Protocol (TLS v1.1 Enabled) | The appliance permits the use of TLS 1.1, which has known cryptographic weaknesses. | High | Disable TLS 1.1 and ensure use of TLS 1.2 or higher with strong cipher suites. |

* **Individual Vulnerability Details:**  
  3.1 Vulnerability: Brute-Force Prevention Disabled (VULN-001)  
  \* Description: The configuration setting "ENABLE BRUTE FORCE PREVENTION" is explicitly disabled, as indicated by the unticked checkbox in the "LOGIN BEHAVIORS" section on Page 1 of the provided document.1 Brute-force prevention systems are designed to detect and block or significantly slow down repeated login attempts from a single source, which are characteristic of automated credential guessing attacks.  
  \* Impact: With this control disabled, attackers can make an unlimited number of attempts to guess user credentials, particularly targeting the administrative interface of the Corelight appliance. This dramatically increases the probability of a successful compromise, especially if weak or common passwords are in use (a risk exacerbated by the lack of enforced password policies, VULN-006). A successful brute-force attack against an administrative account would grant the attacker complete control over the appliance, allowing them to alter configurations, exfiltrate sensitive network data, or disable security monitoring. The absence of this protection effectively removes a critical layer of defense against one of the most common attack vectors for web-accessible interfaces.  
  \* Remediation Steps:  
  1\. Access the Corelight appliance's administrative interface.  
  2\. Navigate to the "LOGIN BEHAVIORS" configuration section.1  
  3\. Enable the "ENABLE BRUTE FORCE PREVENTION" option by ticking the checkbox.  
  4\. If further configurable, set appropriate thresholds for account lockout (e.g., 5-10 incorrect login attempts) and define a suitable lockout duration (e.g., 15-30 minutes, or requiring manual administrator intervention for high-security accounts).  
  5\. Ensure that system logs capture information about failed login attempts and account lockouts, and that alerts are configured to notify administrators of potential brute-force activity.  
  3.2 Vulnerability: Inadequate User Session Management (Auto-Logout for Idle Sessions Disabled) (VULN-002)  
  \* Description: The setting "ENABLE AUTO LOGOUT FOR IDLE USER SESSIONS" is disabled, as shown by the unticked checkbox in the "LOGIN BEHAVIORS" section on Page 1 of the document.1 This feature is responsible for automatically terminating a user's session after a specified period of inactivity.  
  \* Impact: The absence of automatic session logout increases the risk of unauthorized access. If a legitimate user leaves their session active and their workstation unattended (e.g., an unlocked computer in an accessible area), an unauthorized individual could gain access to the Corelight appliance with the authenticated user's privileges. This risk is particularly acute for administrative sessions, as it could lead to immediate system compromise. Furthermore, if an attacker manages to hijack an active session through other means (e.g., cross-site scripting, malware), the lack of an idle timeout allows the attacker to maintain that access for an extended period, increasing the window of opportunity for malicious actions. This vulnerability, when combined with the lack of 2FA (VULN-004, VULN-005), means that physical access to an unattended but logged-in console grants immediate, unfettered access without any secondary authentication challenge.  
  \* Remediation Steps:  
  1\. Access the Corelight appliance's administrative interface.  
  2\. Navigate to the "LOGIN BEHAVIORS" configuration section.1  
  3\. Enable the "ENABLE AUTO LOGOUT FOR IDLE USER SESSIONS" option by ticking the checkbox.  
  4\. Configure an appropriate idle timeout period (e.g., 15 to 30 minutes) that balances security requirements with operational usability, adhering to organizational security policies.  
  3.3 Vulnerability: Lack of Default Password Change Enforcement (VULN-003)  
  \* Description: The configuration "PROMPT USERS TO CHANGE DEFAULT PASSWORD" is disabled, as indicated by the unticked checkbox in the "LOGIN BEHAVIORS" section on Page 1.1 This setting, when enabled, forces users to change their initial password (often a default or administrator-assigned temporary password) upon their first login to the system.  
  \* Impact: Disabling this feature creates a significant risk that accounts, including potentially the primary 'admin' account 1, may continue to use known default or easily guessable passwords. Default credentials for appliances are often publicly documented or easily discoverable by attackers. If the 'admin' account, or any other account, is still using its factory default password, the appliance is trivial to compromise. Even if passwords are set by an administrator during account creation, if users are not forced to change them, these passwords might be weak, shared, or written down, persisting as a security risk. This is a fundamental security hygiene failure, as it bypasses a simple yet effective measure to ensure unique, user-chosen credentials from the outset.  
  \* Remediation Steps:  
  1\. Access the Corelight appliance's administrative interface.  
  2\. Navigate to the "LOGIN BEHAVIORS" configuration section.1  
  3\. Enable the "PROMPT USERS TO CHANGE DEFAULT PASSWORD" option by ticking the checkbox.  
  4\. Crucially, immediately verify the password for the 'admin' user (visible on Page 2 of 1\) and all other existing user accounts. If there is any uncertainty about whether default passwords have been changed, or if passwords do not meet current complexity requirements (see VULN-006), they must be reset to strong, unique values.  
  3.4 Vulnerability: Disabled Two-Factor Authentication (2FA) for 'admin' User (including SSH) (VULN-004)  
  \* Description: The configuration for the 'admin' user, detailed on Page 2 of 1, explicitly states, "2FA not enforced for this user on SSH access." Additionally, the user table on the same page shows the '2FA' status for the 'admin' user as 'X', indicating it is also disabled for web UI access. This means the most privileged account on the appliance relies solely on a single factor (password) for authentication across all access methods.  
  \* Impact: This is a critical vulnerability. The 'admin' account possesses the highest level of privileges on the Corelight appliance. Relying only on a password for this account dramatically increases the risk of compromise through various means such as phishing, malware, credential stuffing, or brute-force attacks (especially given VULN-001). If an attacker compromises the 'admin' password, they gain unrestricted control over the appliance. This would allow them to alter security policies, disable network monitoring, access or exfiltrate sensitive data captured by Corelight, use the appliance as a launchpad for attacks against other systems in the network, or cover their tracks. The lack of 2FA on SSH access is particularly concerning as SSH is a common target for automated attacks against network devices. The absence of 2FA for the "keys to the kingdom" negates one of the most effective defenses against credential theft.  
  \* Remediation Steps:  
  1\. Access the Corelight appliance's administrative interface.  
  2\. Navigate to the user management section for the 'admin' user, as shown on Page 2 of.1  
  3\. Enable and configure a strong 2FA method (e.g., TOTP authenticator app) for the 'admin' user.  
  4\. Ensure that 2FA enforcement applies to both web UI login and SSH access for the 'admin' account.  
  5\. Extend this requirement to all other users who possess administrative or highly privileged access to the appliance.  
  3.5 Vulnerability: Disabled Global Two-Factor Authentication (2FA) (VULN-005)  
  \* Description: The setting "ENABLE GLOBAL TWO-FACTOR AUTHENTICATION (2FA)" is disabled, as indicated by the unticked checkbox in the "SECURE ACCESS" section on Page 3 of.1 This global setting would typically enforce 2FA for all user accounts by default, or at least for defined groups of users. Its disabled state implies that 2FA must be manually enabled on a per-user basis.  
  \* Impact: Without global 2FA enforcement, the security posture regarding multi-factor authentication is inconsistent and reliant on manual configuration for each user. This approach is prone to human error and oversight, potentially leaving many accounts, including privileged ones, protected only by passwords. As demonstrated by the 'admin' account's lack of 2FA (VULN-004), this manual approach has already failed for the most critical account. Any account without 2FA becomes a significantly weaker point in the appliance's defenses and an attractive target for attackers. Managing 2FA on an opt-in or per-user basis increases administrative overhead and the likelihood of misconfiguration compared to a globally enforced policy. This lack of a global mandate for 2FA suggests a less mature approach to security, failing to establish a consistent baseline for user authentication.  
  \* Remediation Steps:  
  1\. Access the Corelight appliance's administrative interface.  
  2\. Navigate to the "SECURE ACCESS" configuration section.1  
  3\. Enable the "ENABLE GLOBAL TWO-FACTOR AUTHENTICATION (2FA)" option by ticking the checkbox.  
  4\. Following enablement, meticulously review all existing user accounts to ensure 2FA is active and correctly configured, paying special attention to any accounts with administrative or elevated privileges.  
  5\. Establish and communicate an organizational policy requiring 2FA for all new user accounts created on the Corelight appliance.  
  3.6 Vulnerability: Unenforced Password Policies (Lack of Complexity and Expiration) (VULN-006)  
  \* Description: Both "ENFORCE PASSWORD POLICY" and "ENFORCE PASSWORD EXPIRATION POLICY" settings are disabled, as shown by unticked checkboxes in the "SECURE ACCESS" section on Page 3 of.1 This indicates that the system does not enforce any rules regarding password strength (such as minimum length, character types – uppercase, lowercase, numbers, symbols) or the maximum age of a password before it must be changed.  
  \* Impact: The absence of enforced password policies significantly weakens the security of all user accounts on the appliance. Users are likely to choose weak, short, easily guessable, or common passwords (e.g., "password123", "admin"), making accounts highly susceptible to brute-force (VULN-001) and dictionary attacks. Without a password expiration policy, passwords, even if initially strong, can remain unchanged indefinitely. If a password is compromised (e.g., through a data breach on another service where the password was reused, or via phishing), it provides an attacker with persistent access. This combination of no complexity requirements and no expiration creates an environment where credential compromise is far more likely and can have long-lasting consequences. These are fundamental security controls, and their absence, particularly when coupled with disabled 2FA (VULN-004, VULN-005) and no brute-force prevention (VULN-001), renders user accounts extremely vulnerable.  
  \* Remediation Steps:  
  1\. Access the Corelight appliance's administrative interface.  
  2\. Navigate to the "SECURE ACCESS" configuration section.1  
  3\. Enable the "ENFORCE PASSWORD POLICY" option. Configure it to mandate strong passwords, including:  
  \* A minimum length (e.g., 12-16 characters).  
  \* A mix of character types (e.g., uppercase letters, lowercase letters, numbers, and special symbols).  
  4\. Enable the "ENFORCE PASSWORD EXPIRATION POLICY" option. Configure:  
  \* A reasonable password expiration period (e.g., every 90 days).  
  \* Password history enforcement to prevent users from reusing recent passwords (e.g., prevent reuse of the last 5-10 passwords).  
  5\. After enabling these policies, consider forcing a password reset for all existing users to ensure their new passwords comply with the strengthened requirements.  
  3.7 Vulnerability: Common Criteria Mode Disabled (VULN-007)  
  \* Description: The setting "ENABLE COMMON CRITERIA MODE" is disabled, as indicated by the unticked checkbox in the "SECURE ACCESS" section on Page 3 of.1 Common Criteria (CC) Mode refers to an internationally recognized set of standards (ISO/IEC 15408\) for IT product security evaluation and certification.4 When enabled on a device, CC Mode typically activates a more stringent security configuration, adhering to specific Protection Profiles (PPs) that define security requirements for a class of devices.5 This often involves enhanced cryptographic measures, stricter access controls, and more robust auditing, among other security hardening features. For example, in some systems, CC Mode can mandate AES-GCM encryption for Bluetooth Long Term Keys, secure Wi-Fi configuration storage, and block bootloader download modes.2  
  \* Impact: By not enabling Common Criteria Mode, the Corelight appliance is not operating under this "elevated set of security standards".2 The specific protections forgone depend on Corelight's particular implementation of CC Mode, but it generally implies a less hardened security posture than the appliance is capable of achieving. This could mean weaker protection for data-at-rest, less secure handling of cryptographic keys, or more permissive system behaviors. If the appliance is deployed in an environment with stringent security requirements (e.g., government, defense, critical infrastructure), operating without CC Mode might lead to non-compliance with contractual or regulatory obligations that mandate or prefer CC-certified configurations.5 While enabling CC Mode can sometimes affect standard device use due to its strict security model 3, its disabled state here means the appliance is not leveraging its full potential for security hardening in environments that might warrant it.  
  \* Remediation Steps:  
  1\. Evaluate Necessity: Thoroughly assess whether the operational environment, organizational security policies, or any regulatory/compliance mandates necessitate or would significantly benefit from the heightened security posture offered by Common Criteria Mode.  
  2\. Consult Vendor Documentation: Refer to Corelight's official documentation to understand the precise security enhancements, configuration changes, and potential operational impacts of enabling CC Mode on this specific appliance model. This is crucial as CC Mode implementations can vary.  
  3\. Enable (If Appropriate): If the evaluation concludes that CC Mode is necessary or beneficial, and after understanding its implications:  
  \* Access the Corelight appliance's administrative interface.  
  \* Navigate to the "SECURE ACCESS" configuration section.1  
  \* Enable the "ENABLE COMMON CRITERIA MODE" option.  
  4\. Thorough Testing: After enabling CC Mode, conduct comprehensive testing of all critical appliance functionalities to ensure that the stricter security settings do not adversely affect legitimate operations or interoperability with other systems.  
  5\. The decision to enable CC Mode should be risk-based. Its availability suggests the appliance is designed for high-security contexts, and its current disabled state warrants careful consideration of whether the current configuration aligns with the security needs of its deployment environment.  
  3.8 Vulnerability: Use of Outdated Cryptographic Protocol (TLS v1.1 Enabled) (VULN-008)  
  \* Description: The configuration setting "ALLOW TLS V11" (interpreted as allowing TLS version 1.1) is enabled, as indicated by the ticked checkbox in the "SECURE ACCESS" section on Page 3 of.1 TLS 1.1 is an obsolete version of the Transport Layer Security protocol, which is used to secure network communications. It has known cryptographic weaknesses and has been formally deprecated by the Internet Engineering Task Force (IETF) and major browser vendors. Modern security standards strongly recommend the use of TLS 1.2 or, preferably, TLS 1.3.  
  \* Impact: Allowing TLS 1.1 exposes communications to and from the Corelight appliance (potentially including its management interface or other services it offers/connects to) to significant security risks. TLS 1.1 lacks support for modern, strong cipher suites and is vulnerable to several known attacks (e.g., certain downgrade attacks, weaknesses exploitable by attacks like BEAST in some contexts). An attacker capable of performing a man-in-the-middle (MitM) attack could potentially force a downgrade to TLS 1.1 and then exploit its weaknesses to decrypt sensitive data, such as login credentials or configuration information, transmitted to or from the appliance. Furthermore, the use of TLS 1.1 can lead to non-compliance with various security standards and regulatory frameworks (e.g., PCI DSS) that mandate the use of secure, current cryptographic protocols. Enabling such an outdated protocol on a security-focused appliance undermines its overall trustworthiness.  
  \* Remediation Steps:  
  1\. Access the Corelight appliance's administrative interface.  
  2\. Navigate to the "SECURE ACCESS" configuration section.1  
  3\. Disable the "ALLOW TLS V11" option by unticking the checkbox.  
  4\. Ensure the appliance is configured to support and prioritize TLS 1.2 and TLS 1.3.  
  5\. Configure the appliance to use only strong, recommended cipher suites with TLS 1.2/1.3.  
  6\. After disabling TLS 1.1, verify that all essential communications to and from the appliance (e.g., management access, data feeds to SIEMs, integrations with other security tools) continue to function correctly. If disabling TLS 1.1 causes compatibility issues with other systems, the priority should be to upgrade those external systems to support modern TLS versions. Maintaining support for TLS 1.1 should be considered a temporary workaround only if absolutely unavoidable and accompanied by other compensating controls and a clear plan for upgrading the dependent systems.

**4.0 Summary of Key Recommendations and Next Steps**

The identified vulnerabilities collectively indicate a Corelight appliance configuration that requires immediate and comprehensive attention to bolster its security posture. Addressing these issues is critical to ensuring the integrity, confidentiality, and availability of the appliance and the data it handles.

* Prioritized Recommendations:  
  The following remediation actions should be prioritized based on their potential impact and the ease of exploitation:  
  1. **Critical Priority \- Authentication & Access Control:**  
     * **Immediately enable and enforce Two-Factor Authentication (2FA) for the 'admin' user** across all access methods (web UI and SSH) (VULN-004).  
     * **Enable Global Two-Factor Authentication (2FA)** to ensure a consistent security baseline for all users (VULN-005).  
  2. **High Priority \- Secure Communication & Credential Protection:**  
     * **Disable support for TLS 1.1** and ensure the appliance uses TLS 1.2 or TLS 1.3 with strong cipher suites for all encrypted communications (VULN-008).  
     * **Enable and enforce strong Password Policies**, including complexity requirements (length, character mix) and regular expiration (VULN-006).  
     * **Ensure all default passwords have been changed** by enabling the prompt for users to change default passwords and verifying current passwords (VULN-003).  
     * **Enable Brute-Force Prevention** mechanisms to protect against automated credential guessing attacks (VULN-001).  
  3. **Medium Priority \- Session Management & System Hardening:**  
     * **Enable Auto-Logout for Idle User Sessions** to reduce the risk from unattended active sessions (VULN-002).  
     * **Evaluate and strongly consider enabling Common Criteria Mode** (VULN-007), after performing due diligence on its operational impact and aligning its activation with the organization's security requirements for the appliance.  
* Holistic Security Approach:  
  The series of misconfigurations identified 1 suggests that security may not have been a primary focus during the initial setup or ongoing maintenance of the appliance. Simply addressing these individual settings is a crucial first step, but a more holistic and proactive approach to security management is warranted.  
  * It is recommended to conduct a **comprehensive security review** of the Corelight appliance that extends beyond the settings discussed. This should include verifying that the appliance is running the latest stable firmware and software versions, reviewing network segmentation to ensure the appliance is appropriately isolated, and confirming that logging and alerting mechanisms are adequately configured to detect and respond to security events.  
  * The pattern of disabled fundamental security controls points towards a potentially reactive security posture. A shift towards **proactive security management practices** is essential. This includes performing regular security audits of the appliance's configuration, staying informed about emerging threats and vulnerabilities relevant to Corelight products, and adhering to security best practices for network infrastructure devices.  
* Ongoing Monitoring:  
  Continuous monitoring of the Corelight appliance's security settings, logs, and overall health is vital. Implement procedures to regularly review audit logs for suspicious activity, unauthorized access attempts, or unexpected configuration changes. Configuration drift should be monitored and corrected promptly.  
* User Training:  
  Ensure that all personnel responsible for administering the Corelight appliance receive adequate training on secure configuration, management, and monitoring practices. Administrator awareness is a key component of maintaining a strong security posture for critical systems.

**5.0 Conclusion**

The Corelight appliance is a valuable asset for network visibility and security monitoring. However, the configuration settings reviewed 1 reveal multiple vulnerabilities that significantly undermine its security and expose it to a high risk of compromise. The identified issues span critical areas including authentication, session management, password security, cryptographic protocols, and overall system hardening.

Implementing the specific remediation steps detailed in this report, particularly the immediate enforcement of Two-Factor Authentication, the disablement of TLS 1.1, and the establishment of robust password policies, will substantially improve the security posture of the Corelight appliance. Adopting a more comprehensive and proactive approach to security management, including regular reviews, updates, and ongoing monitoring, is essential for long-term resilience against evolving cyber threats. Addressing these vulnerabilities will not only protect the appliance itself but also enhance the security of the network environment it is tasked with safeguarding. Further assistance or clarification regarding these findings and recommendations can be provided as needed.

#### **Works cited**

1. Corelight.pdf  
2. Corporate-owned Android Enterprise device restriction settings in Microsoft Intune, accessed on June 4, 2025, [https://learn.microsoft.com/en-us/intune/intune-service/configuration/device-restrictions-android-for-work](https://learn.microsoft.com/en-us/intune/intune-service/configuration/device-restrictions-android-for-work)  
3. Create an Android Common Criteria Mode Policy \- JumpCloud, accessed on June 4, 2025, [https://jumpcloud.com/support/create-an-android-common-criteria-mode-policy](https://jumpcloud.com/support/create-an-android-common-criteria-mode-policy)  
4. docs.omnissa.com, accessed on June 4, 2025, [https://docs.omnissa.com/bundle/GUID-AWT-KNOX-INTRO/page/CommonCriteriaCCModeKnox.html\#:\~:text=Common%20Criteria%20(CC)%20Mode%20is,vendor%20compliance%20with%20these%20requirements.](https://docs.omnissa.com/bundle/GUID-AWT-KNOX-INTRO/page/CommonCriteriaCCModeKnox.html#:~:text=Common%20Criteria%20\(CC\)%20Mode%20is,vendor%20compliance%20with%20these%20requirements.)  
5. What is Common Criteria Certification, and Why Is It Important? \- Blancco, accessed on June 4, 2025, [https://blancco.com/resources/blog-what-is-common-criteria-certification-why-is-it-important/](https://blancco.com/resources/blog-what-is-common-criteria-certification-why-is-it-important/)
