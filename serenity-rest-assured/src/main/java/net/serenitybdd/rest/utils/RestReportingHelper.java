package net.serenitybdd.rest.utils;

import com.jayway.restassured.filter.Filter;
import com.jayway.restassured.filter.log.LogDetail;
import com.jayway.restassured.http.ContentType;
import com.jayway.restassured.response.Response;
import net.serenitybdd.core.Serenity;
import net.serenitybdd.core.rest.RestMethod;
import net.serenitybdd.core.rest.RestQuery;
import net.serenitybdd.rest.RestStepListener;
import net.serenitybdd.rest.decorators.request.RequestSpecificationDecorated;
import net.serenitybdd.rest.filters.FieldsRecordingFilter;
import net.thucydides.core.steps.ExecutedStepDescription;
import net.thucydides.core.steps.StepEventBus;
import net.thucydides.core.steps.StepFailure;
import org.apache.commons.lang3.ObjectUtils;

import java.util.HashMap;
import java.util.Map;

import static net.thucydides.core.steps.StepEventBus.getEventBus;
import static org.apache.commons.lang3.ObjectUtils.*;


/**
 * User: YamStranger
 * Date: 4/6/16
 * Time: 7:51 AM
 */
public class RestReportingHelper {

    public RestReportingHelper() {
        getEventBus().registerListener(new RestStepListener());
    }

    private static boolean shouldRecordResponseBodyFor(Response result) {
        final ContentType type = ContentType.fromContentType(result.contentType());
        return type != null && (ContentType.JSON == type || ContentType.XML == type
                || ContentType.TEXT == type || ContentType.HTML == type);
    }

    public RestQuery recordRestSpecificationData(final RestMethod method, final RequestSpecificationDecorated spec,
                                                 final String path, final Object... params) {
        final Map<LogDetail, String> values = new HashMap<>();
        for (final Filter filter : spec.getDefinedFilters()) {
            if (filter instanceof FieldsRecordingFilter) {
                final FieldsRecordingFilter internal = (FieldsRecordingFilter) filter;
                values.put(internal.logDetail(), internal.recorded());
            }
        }
        final RestQuery query = RestQuery.
                withMethod(method).andPath(ObjectUtils.firstNonNull(values.get(LogDetail.PATH), "")).
                withContentType(String.valueOf(
                                ContentType.fromContentType(spec.getRequestContentType()))
                ).
                withContent(firstNonNull(values.get(LogDetail.BODY), "")).
                withRequestCookies(firstNonNull(values.get(LogDetail.COOKIES), "")).
                withRequestHeaders(firstNonNull(values.get(LogDetail.HEADERS), ""));
        return query;
    }

    public void registerCall(final RestMethod method, final Response response,
                             final RequestSpecificationDecorated spec,
                             final String path, final Object... params) {
        RestQuery restQuery = recordRestSpecificationData(method, spec, path, params);
        final RestResponseRecordingHelper helper = new RestResponseRecordingHelper(true,
                LogDetail.HEADERS, LogDetail.COOKIES);
        final Map<LogDetail, String> values = helper.print(response);
        if (shouldRecordResponseBodyFor(response)) {
            restQuery = restQuery.withResponse(response.getBody().prettyPrint());
        }
        restQuery = restQuery.withStatusCode(response.getStatusCode())
                .withResponseHeaders(firstNonNull(values.get(LogDetail.HEADERS), ""))
                .withResponseCookies(firstNonNull(values.get(LogDetail.COOKIES), ""));
        getEventBus().getBaseStepListener().recordRestQuery(restQuery);
    }

    public void registerCall(final RestMethod method, final RequestSpecificationDecorated spec, final String path,
                             final RuntimeException throwable, final Object... params) {
        RestQuery restQuery = recordRestSpecificationData(method, spec, path, params);
        ExecutedStepDescription description = ExecutedStepDescription.withTitle(restQuery.toString());
        StepFailure failure = new StepFailure(description, throwable);
        StepEventBus.getEventBus().stepStarted(description);
        getEventBus().getBaseStepListener().recordRestQuery(restQuery);
        StepEventBus.getEventBus().stepFailed(failure);
        if (Serenity.shouldThrowErrorsImmediately()) {
            throw throwable;
        }
    }
}
