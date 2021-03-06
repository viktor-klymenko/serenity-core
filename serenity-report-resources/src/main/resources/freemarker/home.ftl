<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Serenity Reports</title>

    <link rel="shortcut icon" href="favicon.ico">

    <#include "libraries/common.ftl">
    <#include "libraries/jquery-ui.ftl">
    <#include "libraries/datatables.ftl">
    <#assign pie = true>
    <#include "libraries/jqplot.ftl">

    <#include "components/tag-list.ftl">
    <#include "components/test-outcomes.ftl">


<#assign successfulManualTests = (testOutcomes.count("manual").withResult("SUCCESS") > 0)>
<#assign pendingManualTests = (testOutcomes.count("manual").withResult("PENDING") > 0)>
<#assign ignoredManualTests = (testOutcomes.count("manual").withResult("IGNORED") > 0)>
<#assign failingManualTests = (testOutcomes.count("manual").withResult("FAILURE") > 0)>

    <script class="code" type="text/javascript">$(document).ready(function () {
        var test_results_plot = $.jqplot('test_results_pie_chart', [
            [
                ['Passing', ${testOutcomes.proportionOf("automated").withResult("success")}],
                <#if (successfulManualTests)>['Passing (manual)', ${testOutcomes.proportionOf("manual").withResult("success")}],</#if>
                ['Pending', ${testOutcomes.proportionOf("automated").withResult("pending")}],
                <#if (pendingManualTests)>['Pending (manual)', ${testOutcomes.proportionOf("manual").withResult("pending")}],</#if>
                ['Ignored', ${testOutcomes.proportionOf("automated").withResult("ignored")}],
                <#if (ignoredManualTests)>['Ignored (manual)', ${testOutcomes.proportionOf("manual").withResult("ignored")}],</#if>
                ['Failing', ${testOutcomes.proportionOf("automated").withResult("failure")}],
                <#if (failingManualTests)>['Failing (manual)', ${testOutcomes.proportionOf("manual").withResult("failure")}],</#if>
                ['Errors',  ${testOutcomes.proportionOf("automated").withResult("error")}],
                ['Compromised',  ${testOutcomes.proportionOf("automated").withResult("compromised")}]
            ]
        ], {

            gridPadding: {top: 0, bottom: 38, left: 0, right: 0},
            seriesColors: ['#30cb23',
                <#if (successfulManualTests)>'#009818',</#if>
                '#a2f2f2',
                <#if (pendingManualTests)>'#8bb1df',</#if>
                '#eeeadd',
                <#if (ignoredManualTests)>'#d3d3d3',</#if>
                '#f8001f',
                <#if (failingManualTests)>'#a20019',</#if>
                '#fc6e1f',
                'fuchsia'],
            seriesDefaults: {
                renderer: $.jqplot.PieRenderer,
                trendline: { show: false },
                rendererOptions: { padding: 8, showDataLabels: true }
            },
            legend: {
                show: true,
                placement: 'outside',
                rendererOptions: {
                    numberRows: 2
                },
                location: 's',
                marginTop: '15px'
            },
            series: [
                {label: '${testOutcomes.count("automated").withResult("success")} / ${testOutcomes.total} tests passed' },
            <#if (successfulManualTests)>
                {label: '${testOutcomes.count("manual").withResult("success")} / ${testOutcomes.total} manual tests passed' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("pending")} / ${testOutcomes.total} tests pending'},
            <#if (pendingManualTests)>
                {label: '${testOutcomes.count("manual").withResult("pending")} / ${testOutcomes.total} manual tests pending' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("ignored")} / ${testOutcomes.total} tests not executed'},
            <#if (ignoredManualTests)>
                {label: '${testOutcomes.count("manual").withResult("ignored")} / ${testOutcomes.total} manual tests not executed' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("failure")} / ${testOutcomes.total} tests failed'},
            <#if (failingManualTests)>
                {label: '${testOutcomes.count("manual").withResult("failure")} / ${testOutcomes.total} manual tests failed' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("error")} / ${testOutcomes.total} errors'},
                {label: '${testOutcomes.count("automated").withResult("compromised")} / ${testOutcomes.total} compromised tests'}
            ]
        });

        var weighted_test_results_plot = $.jqplot('weighted_test_results_pie_chart', [
            [
                ['Passing', ${testOutcomes.proportionalStepsOf("automated").withResult("success")}],
                <#if (successfulManualTests)>['Passing (manual)', ${testOutcomes.proportionalStepsOf("manual").withResult("success")}],</#if>
                ['Pending', ${testOutcomes.proportionalStepsOf("automated").withResult("pending")}],
                <#if (pendingManualTests)>['Pending (manual)', ${testOutcomes.proportionalStepsOf("manual").withResult("pending")}],</#if>
                ['Ignored', ${testOutcomes.proportionalStepsOf("automated").withResult("ignored")}],
                <#if (ignoredManualTests)>['Ignored (manual)', ${testOutcomes.proportionalStepsOf("manual").withResult("ignored")}],</#if>
                ['Failing', ${testOutcomes.proportionalStepsOf("automated").withResult("failure")}],
                <#if (failingManualTests)>['Failing (manual)', ${testOutcomes.proportionalStepsOf("manual").withResult("failure")}],</#if>
                ['Errors', ${testOutcomes.proportionalStepsOf("automated").withResult("error")}],
                ['Compromised', ${testOutcomes.proportionalStepsOf("automated").withResult("compromised")}],
            ]
        ], {

            gridPadding: {top: 0, bottom: 38, left: 0, right: 0},
            seriesColors: ['#30cb23',
                <#if (successfulManualTests)>'#28a818',</#if>
                '#a2f2f2',
                <#if (pendingManualTests)>'#8be1df',</#if>
                '#eeeadd',
                <#if (ignoredManualTests)>'#d3d3d3',</#if>
                '#f8001f',
                <#if (failingManualTests)>'#e20019',</#if>
                '#fc6e1f',
                'mediumvioletred'],

            seriesDefaults: {
                renderer: $.jqplot.PieRenderer,
                trendline: { show: false },
                rendererOptions: { padding: 8, showDataLabels: true }
            },
            legend: {
                show: true,
                placement: 'outside',
                rendererOptions: {
                    numberRows: 2
                },
                location: 's',
                marginTop: '15px'
            },
            series: [
                {label: '${testOutcomes.count("automated").withResult("success")} / ${testOutcomes.total} tests passed (${testOutcomes.decimalPercentageSteps("automated").withResult("success")}% of all test steps)' },
            <#if (successfulManualTests)>
                {label: '${testOutcomes.count("manual").withResult("success")} / ${testOutcomes.total} manual tests passed (${testOutcomes.decimalPercentageSteps("manual").withResult("success")}% of all test steps)' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("pending")} / ${testOutcomes.total} tests pending'},
            <#if (pendingManualTests)>
                {label: '${testOutcomes.count("manual").withResult("pending")} / ${testOutcomes.total} manual tests pending' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("ignored")} / ${testOutcomes.total} tests not executed'},
            <#if (ignoredManualTests)>
                {label: '${testOutcomes.count("manual").withResult("ignored")} / ${testOutcomes.total} manual tests not executed' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("failure")} / ${testOutcomes.total} tests failed (${testOutcomes.decimalPercentageSteps("automated").withResult("failure")}% of all test steps)'},
            <#if (failingManualTests)>
                {label: '${testOutcomes.count("manual").withResult("failure")} / ${testOutcomes.total} manual tests failed (${testOutcomes.decimalPercentageSteps("manual").withResult("failure")}% of all test steps)' },
            </#if>
                {label: '${testOutcomes.count("automated").withResult("error")} / ${testOutcomes.total} errors (${testOutcomes.decimalPercentageSteps("automated").withResult("error")}% of all test steps)'}
            <#if (testOutcomes.count("automated").withResult("compromised") > 0)>
                ,{label: '${testOutcomes.count("automated").withResult("compromised")} / ${testOutcomes.total} tests compromised (${testOutcomes.decimalPercentageSteps("automated").withResult("compromised")}% of all test steps)'}
            </#if>
            ]
        });

        // Results table
        $('#test-results-table').DataTable({
            "order": [
                [ 1, "asc" ]
            ],
            "pageLength": 100,
            "lengthMenu": [ [50, 100, 200, -1] , [50, 100, 200, "All"] ]
        });

        // Pie charts
        $('#test-results-tabs').tabs();

        $('#toggleNormalPieChart').click(function () {
            $("#test_results_pie_chart").toggle();
        });

        $('#toggleWeightedPieChart').click(function () {
            $("#weighted_test_results_pie_chart").toggle();
        });

    <#if !reportOptions.displayPiechart>
        $("#test_results_pie_chart").hide();
        $("#weighted_test_results_pie_chart").hide();
    </#if>


    })
    ;
    </script>
</head>

<body class="results-page">
<div id="topheader">
    <div id="topbanner">
        <div id="logo"><a href="index.html"><img src="images/serenity-bdd-logo.png" border="0"/></a></div>
        <div id="projectname-banner" style="float:right">
            <span class="projectname">${reportOptions.projectName}</span>
        </div>
    </div>
</div>

<div class="middlecontent">

<#assign tagsTitle = 'Related Tags' >
<#if (testOutcomes.label == '')>
    <#assign resultsContext = ''>
    <#assign pageTitle = 'Test Results: All Tests' >
<#else>
    <#assign resultsContext = '> ' + testOutcomes.label>
    <#if (currentTagType! != '')>
        <#assign pageTitle = "<i class='fa fa-tags'></i> " + inflection.of(currentTagType!"").asATitle() + ': ' +  inflection.of(testOutcomes.label).asATitle() >
    <#else>
        <#assign pageTitle = inflection.of(testOutcomes.label).asATitle() >
    </#if>
</#if>
<div id="contenttop">
<#--<div class="leftbg"></div>-->
    <div class="middlebg">
        <span class="breadcrumbs"><a href="index.html">Home</a>
        <#if (breadcrumbs?has_content)>
            <#list breadcrumbs as breadcrumb>
                <#assign breadcrumbReport = absoluteReportName.forRequirementOrTag(breadcrumb) />
                <#assign breadcrumbTitle = inflection.of(breadcrumb.shortName).asATitle() >
                > <a href="${breadcrumbReport}">${formatter.truncatedHtmlCompatible(breadcrumbTitle,30)}</a>
            </#list>
        <#else>
            <#if currentTagType?has_content>
                > ${inflection.of(currentTagType!"").asATitle()}
            </#if>
        </#if>
            <#if testOutcomes.label?has_content>
                > ${formatter.truncatedHtmlCompatible(inflection.of(testOutcomes.label).asATitle(),80)}
            </#if>
        </span>
    </div>
    <div class="rightbg"></div>
</div>

<div class="clr"></div>

<!--/* starts second table*/-->
<#include "menu.ftl">
<@main_menu selected="home" />
<div class="clr"></div>
<div id="beforetable"></div>
<div id="results-dashboard">
<div class="middlb">
<div class="table">

<h2>${pageTitle}</h2>
<table class='overview'>
    <tr>
        <td width="375px" valign="top">
            <div class="test-count-summary">
                <span class="test-count-title">${testOutcomes.totalTestScenarios}
                    test scenarios <#if (testOutcomes.hasDataDrivenTests())>(${testOutcomes.total} tests in all, including ${testOutcomes.totalDataRows}
                    rows of test data)</#if></span>
                <div>
            <#assign successReport = reportName.withPrefix(currentTag).forTestResult("success") >
            <#assign failureReport = reportName.withPrefix(currentTag).forTestResult("failure") >
            <#assign errorReport = reportName.withPrefix(currentTag).forTestResult("error") >
            <#assign compromisedReport = reportName.withPrefix(currentTag).forTestResult("compromised") >
            <#assign pendingReport = reportName.withPrefix(currentTag).forTestResult("pending") >
            <#assign skippedReport = reportName.withPrefix(currentTag).forTestResult("skipped") >
            <#assign ignoredReport = reportName.withPrefix(currentTag).forTestResult("ignored") >

            <#assign totalCount = testOutcomes.totalTests.total >
            <#assign successCount = testOutcomes.totalTests.withResult("success") >
            <#assign pendingCount = testOutcomes.totalTests.withResult("pending") >
            <#assign ignoredCount = testOutcomes.totalTests.withResult("ignored") >
            <#assign skippedCount = testOutcomes.totalTests.withResult("skipped") >
            <#assign failureCount = testOutcomes.totalTests.withResult("failure") >
            <#assign errorCount = testOutcomes.totalTests.withResult("error") >
            <#assign compromisedCount = testOutcomes.totalTests.withResult("compromised") >

                <span class="test-count">
                    ${successCount}
                    <#if (successCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${successReport}">passed</a>
                    <#else>passed</#if>,
                </span>
                <span class="test-count">
                    ${pendingCount}
                    <#if (pendingCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${pendingReport}">pending</a>
                    <#else>pending</#if>,
                </span>
                <span class="test-count">
                    ${failureCount}
                    <#if (failureCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${failureReport}">failed</a>
                    <#else>failed</#if>,
                </span>
                <span class="test-count">
                    ${errorCount}
                    <#if (errorCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${errorReport}">with errors</a>
                    <#else>errors</#if>,
                </span>
                <span class="test-count">
                    ${compromisedCount}
                    <#if (compromisedCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${compromisedReport}">compromised tests</a>
                    <#else>compromised</#if>,
                </span>
                <span class="test-count">
                    ${ignoredCount}
                    <#if (ignoredCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${ignoredReport}">ignored</a>
                    <#else>ignored</#if>,
                </span>
                <span class="test-count">
                    ${skippedCount}
                    <#if (skippedCount > 0 && report.shouldDisplayResultLink)>
                        <a href="${relativeLink}${skippedReport}">skipped</a>
                    <#else>skipped</#if>
                </span>
                <#if (csvReport! != '')>
                    <a href="${csvReport}">[CSV]</a>
                </#if>
                </div>
            </div>

            <div id="test-results-tabs">
                <ul>
                    <li><a href="#test-results-tabs-1">Test Count</a></li>
                    <li><a href="#test-results-tabs-2">Weighted Tests</a></li>
                </ul>
                <div id="test-results-tabs-1">
                    <table>
                        <tr>
                            <td colspan="2">
                                <span class="caption">Total number of tests that pass, fail, or are pending.</span>
                                <span class="togglePieChart" id="toggleNormalPieChart"><a href="#">Show/Hide Pie Chart</a></span>
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align: text-top;">
                                <div id="test_results_pie_chart"></div>
                            </td>
                            <td class="related-tags-section">
                                <div>
                                <#include "test-result-summary.ftl"/>
                                </div>
                                <div>
                                <#if reportOptions.showRelatedTags>
                                    <@list_tags weighted="false"/>
                                </#if>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="test-results-tabs-2">
                    <table>
                        <tr>
                            <td colspan="2">
                                <span class="caption">Test results weighted by test size in steps (average steps per test: ${testOutcomes.averageTestSize}) .</span>
                                <span class="togglePieChart" id="toggleWeightedPieChart"><a href="#">Show/Hide Pie
                                    Chart</a></span>
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align: text-top;">
                                <div id="weighted_test_results_pie_chart"></div>
                            </td>
                            <td class="related-tags-section">
                                <div>
                                <#include "test-result-summary.ftl"/>
                                </div>
                                <div>
                                <#if reportOptions.showRelatedTags>
                                   <@list_tags weighted="true"/>
                                </#if>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </td>

    </tr>
</table>

<@test_results testOutcomes=testOutcomes title="Tests" id="test-results-table"/>

</div>
</div>
</div>
</div>
<div id="beforefooter"></div>
<div id="bottomfooter">
    <span class="version">Serenity version ${serenityVersionNumber}</span>
</div>


</body>
</html>
