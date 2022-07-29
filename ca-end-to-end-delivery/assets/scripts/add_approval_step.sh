gh repo clone $GIT_REPO
cd ~/$GIT_NEW_REPO_NAME
cat << EOF > ~/$GIT_NEW_REPO_NAME/shipyard.yaml
apiVersion: "spec.keptn.sh/0.2.2"
kind: "Shipyard"
metadata:
  name: "shipyard-delivery"
spec:
  stages:
    - name: "qa"
      sequences:
        - name: "delivery"
          tasks:
            - name: "je-deployment"
            - name: "je-test"

    - name: "production"
      sequences:
        - name: "delivery"
          triggeredOn:
            - event: "qa.delivery.finished"
          tasks:
            - name: "approval"
              properties:
                pass: "manual"
                warning: "manual"
            - name: "je-deployment"
EOF
git remote set-url origin https://$GIT_USER:$GITHUB_TOKEN@github.com/$GIT_USER/$GIT_NEW_REPO_NAME.git
git config --global user.email "demo@cloudautomation.io"
git config --global user.name "Cloud Automation"
git add -A
git commit -m "add approval step to production"
git push

echo ""
echo "===================================================="
echo "Trigger another delivery of helloservice v0.1.1     "
echo "===================================================="

cloud_automation trigger delivery \
--project=fulltour \
--service=helloservice \
--image="ghcr.io/podtato-head/podtatoserver:v0.1.1" \
--labels=image="ghcr.io/podtato-head/podtatoserver",version="v0.1.1"