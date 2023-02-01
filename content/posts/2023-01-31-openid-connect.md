---
title: Tokens, Please
description: 'Comparing OpenID Connect With Video Game "Papers, Please"'
date: 2023-02-022
author: Todd Turner
# arrange the categories alphabetically
categories: ['AWS', 'CI/CD', 'Security']
# arrange the tags alphabetically
tags: ['authentication', 'aws', 'github', 'iam', 'oidc']
slug: 'github-actions-oidc'
---

Ah, access control.

It's a topic that I have been thinking about a lot recently.

Why you ask?

Because I have been working hard on a security project? Been DevSecOps-ing my little heart out? Of Course not!

I have been re-playing one of my favorite video games of all time, ["*Papers, Please*"][link-1], by developer [Lucas Pope][link-4].

It had been a few years since I had first played the game, but upon replaying it, I couldn't shake off the feeling of recent deja vu.
I pondered why I felt this way, and then it hit me.
I had recently secured this blog's deployment pipeline with OpenID Connect (OIDC).

It then dawned on me that OpenIDC is a lot like enforcing immigration control policy in the fictional country of Arstotzka.

Not sure what I am on about? Let me explain...

![gif of papers please title][gif-1]

## What is Papers, Please?

In the video game "*Papers, Please*," the player takes on the role of an immigration inspector in a dystopian country, Arstotzka.
Your role as the immigration inspector is enforcing the various, and ever-changing, border control policies set by the Arstotzkan government.

This is done by tediously verifying the identification and authorisation documents of each traveler who passes through the border checkpoint.
The documents need to be cross-referenced with the various rules and regulations that apply at the time of inspection.
You as the player, must make a split-second decision on who is or isn't allowed into the country.

![gif of papers please game-play][gif-2]


Get it right, and you will be rewarded with promotions and praise; your family will prosper, Arstotzka will grow from strength-to-strength!

Get it wrong, and the consequences could be dire...


![gif of papers please when you get it wrong][gif-3]

## So What Does OIDC Have To Do With This?

There is a clear parallel between the game and the process of securing a cloud resources with OIDC.
Let's first take a look at the key elements in the game and how they interact with each other.

![image of papers please workflow][image-1]

Let's work through this diagram:

1. The Arstotzkan government creates the immigration policy that determines who can enter the country and under what conditions.
2. The traveler will go to the appropriate Documents Department and obtain the necessary identification and documents. 
3. The department generates these documents, based on the requesters personal characteristics and stated intentions, which are returned to the requester.
4. The hopeful border-crosser will now take these documents and present them to the immigration inspector at the border.
5. The immigration inspector will analyse the documents against the applicable immigration policy and make a decision to approve or deny entry.
6. The traveler's passport is then stamped with either an approval or denial stamp, depending on the outcome of the inspection and returned.

Now let's take a look at how this process maps back to securing cloud resources with OIDC.

First, let's look at the workflow diagram:

![image of papers please workflow][image-2]

Again, let's work through the steps of the workflow; but this time, I want you to think about how each step can be applied to Papers, Please.

1. The AWS Account Owner (or resource owner) creates an OIDC Trust Policy in IAM.
This trust policy determines which OIDC tokens, and subsequent claims on said token, are accepted for the role that is being requested.
2. The Github workflow will run a step to obtain an OIDC token from the 
OIDC provider. This provider can be customised to your desired identity provider, or just kept with the default Github provider.
3. The OIDC provider will generate a JSON Web Token (JWT) that contains the identity of the user and the claims that the user has requested.
4. The Github workflow will then present this token to the appropriate AWS IAM service. 
5. AWS IAM will inspect the token for authenticity and review the claims that are contained within it against the OIDC Trust Policy.
6. If the token is deemed valid, AWS IAM will grant the user a temporary access token that can be used to access the AWS resources. Otherwise, the user will be denied access.

Let's summarise the comparison between the game and the OIDC authetication process:


| **Papers, Please** | **OIDC Workflow** | **Role** |
| --- | --- | --- |
| **Arstotzka Government** | **AWS Account Owner** |  Creates the governing policies. |
| **Immigration Policy** | **OIDC Trust Policy** |  Outlines the rules and regulations that determine who can access what and under what conditions. |
| **Traveler** | **Github Workflow** | The entity requesting access to areas under restricted access. |
| **ID and Documents** | **JWT** | The official documents outlining the identity of the requesting entity and related supporting claims. |
| **Immigration Inspector** | **AWS IAM** | Inspects the ID and claims of the requesting entity and compares these claims to the official policies. |


## So What?

That is a great question!

Essentially, the game is a great way to visualise the process of securing cloud resources with OIDC.
Official documentation can be a bit dry and hard to understand, but a game is a great way to learn and understand a new concept.

![papers please approved stamp][gif-4]

## Anything Else?

Well yes, there is one more thing.

One of the interesting takeaways from the game is that access control is a delicate balance between security and usability.
The more complex the access control policies, the more difficult it is to enforce them.
The more difficult it is to enforce them, the more likely you will get it wrong.

This balancing relationship applies directly to cloud and CI/CD security.

Pipeline secrets, API keys, IAM credentials, etc. are all tedious and complex to manage and maintain.
Any manual process of providing keys or manual authentication to systems is a source of friction which is prone to error or will deter people from interacting with the system in the first place.

So when I was thinking about how to secure my blog's deployment pipeline, I wanted to make the security not only as frictionless as possible, without compromising security.
Bonus points if it was also simple to implement and easy to maintain.

*OIDC met this criteria perfectly.*

To summarise the benefits of OIDC:

**1. It is Simple to Implement.**
[Enabling OIDC in AWS][link-2] is as simple as creating a OIDC trust policy in AWS IAM and utilising the `aws-actions/configure-aws-credentials` action in your Github workflow.

**2. It is Secure.**
The JWT generated by the OIDC provider is signed with a private key and can be verified with the public key. So you can be sure that the token is coming from the OIDC provider and not a malicious third party.

**3. It is Flexible.**
The OIDC trust policy can be as fine grained or as broad as you want.
[A variety of claims][link-3] that must be present in the JWT can be specified.

**4. It is Scalable.**
You can use the same OIDC trust policy across multiple AWS accounts and multiple AWS regions. This means that you can easily scale your deployment pipeline to multiple environments.

**5. It is Easy to Maintain.**
No more management of API keys, IAM credentials or secrets. 

## In Summary...

I hope that this post has given you a better understanding of how OIDC works and how it can be used to secure your cloud resources, particularly when being interfaced with a CI/CD pipeline.

Oh, and if you haven't played *Papers, Please*, I highly recommend it. It is a great game and a great way to learn about the complexities of access control.

![glory to arstotzka][gif-5]

[link-1]: https://papersplea.se/
[link-2]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws
[link-3]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#configuring-the-oidc-trust-with-the-cloud
[link-4]: https://dukope.com/

[image-1]: https://images.toddtee.sh/2023/github-actions-oidc/papers-please-workflow.jpg
[image-2]: https://images.toddtee.sh/2023/github-actions-oidc/aws-oidc-workflow.jpg

[gif-1]: https://images.toddtee.sh/2023/github-actions-oidc/papers-please.gif 
[gif-2]: https://images.toddtee.sh/2023/github-actions-oidc/papers-please-gameplay.gif 
[gif-3]: https://images.toddtee.sh/2023/github-actions-oidc/papers-please-got-it-wrong.gif 
[gif-4]: https://images.toddtee.sh/2023/github-actions-oidc/papers-please-approved.gif 
[gif-5]: https://images.toddtee.sh/2023/github-actions-oidc/glory-to-arstotzka.gif 
