mkdir -p ./allure-history
cp -r ./gh-pages/. ./allure-history
ls ./allure-history

REPOSITORY_OWNER_SLASH_NAME=${{ github.repository }}
REPOSITORY_NAME=${REPOSITORY_OWNER_SLASH_NAME##*/}
GITHUB_PAGES_WEBSITE_URL="https://${{ github.repository_owner }}.github.io/${REPOSITORY_NAME}"
echo "Github pages url $GITHUB_PAGES_WEBSITE_URL"


COUNT=$( ( ls ./allure-history | wc -l ) )
echo "count folders in allure-history: ${COUNT}"
echo "keep reports count 5"
INPUT_KEEP_REPORTS=$((5+1))
echo "if ${COUNT} > ${INPUT_KEEP_REPORTS}"
if (( ${COUNT} > ${INPUT_KEEP_REPORTS} )); then
  cd ./allure-history
  echo "remove index.html last-history"
  rm index.html last-history -rv
  echo "remove old reports"
  ls | sort -n | head -n -$((5-2)) | xargs rm -rv;
  cd ${GITHUB_WORKSPACE}
fi

echo "index.html"
echo "<!DOCTYPE html><meta charset=\"utf-8\"><meta http-equiv=\"refresh\" content=\"0; URL=${GITHUB_PAGES_WEBSITE_URL}/${{ github.run_number }}/\">" > ./allure-history/index.html # path
echo "<meta http-equiv=\"Pragma\" content=\"no-cache\"><meta http-equiv=\"Expires\" content=\"0\">" >> ./allure-history/index.html
#cat ./allure-history/index.html

#echo "executor.json"
echo '{"name":"GitHub Actions","type":"github","reportName":"Allure Report with history",' > executor.json
echo "\"url\":\"${GITHUB_PAGES_WEBSITE_URL}\"," >> executor.json # ???
echo "\"reportUrl\":\"${GITHUB_PAGES_WEBSITE_URL}/${{ github.run_number }}/\"," >> executor.json
echo "\"buildUrl\":\"https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}\"," >> executor.json
echo "\"buildName\":\"GitHub Actions Run #${{ github.run_id }}\",\"buildOrder\":\"${{ github.run_number }}\"}" >> executor.json
#cat executor.json
mv ./executor.json ./allure-results

#environment.properties
echo "URL=${GITHUB_PAGES_WEBSITE_URL}" >> ./allure-results/environment.properties

echo "keep allure history from gh-pages/last-history to allure-results/history"
cp -r ./gh-pages/last-history/. ./allure-results/history

echo "generating report from allure-results to allure-report ..."
#ls -l allure-results
allure generate --clean allure-results -o allure-report
#echo "listing report directory ..."
#ls -l allure-report

echo "copy allure-report to allure-history/${{ github.run_number }}"
cp -r ./allure-report/. ./allure-history/${{ github.run_number }}
echo "copy allure-report history to /allure-history/last-history"
cp -r ./allure-report/history/. ./allure-history/last-history

echo "Check inside allure-history"
ls ./allure-history
echo "Inside gh-pages"
ls ./gh-pages