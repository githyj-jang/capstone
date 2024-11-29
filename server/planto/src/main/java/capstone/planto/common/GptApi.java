package capstone.planto.common;

import io.swagger.v3.oas.models.PathItem;
import org.springframework.beans.factory.annotation.Value;

import kong.unirest.Unirest;
import kong.unirest.HttpResponse;

public class GptApi {
    @Value("${gpt.api.key}")
    private String apiKey;

    private Unirest Unirest;
    HttpResponse<String> response = Unirest.post("https://api.perplexity.ai/chat/completions")
            .header("Authorization", "Bearer <token>")
            .header("Content-Type", "application/json")
            .body("{\n  \"model\": \"llama-3.1-sonar-small-128k-online\",\n  \"messages\": [\n    {\n      \"role\": \"system\",\n      \"content\": \"Be precise and concise.\"\n    },\n    {\n      \"role\": \"user\",\n      \"content\": \"How many stars are there in our galaxy?\"\n    }\n  ],\n  \"max_tokens\": \"Optional\",\n  \"temperature\": 0.2,\n  \"top_p\": 0.9,\n  \"return_citations\": true,\n  \"search_domain_filter\": [\n    \"perplexity.ai\"\n  ],\n  \"return_images\": false,\n  \"return_related_questions\": false,\n  \"search_recency_filter\": \"month\",\n  \"top_k\": 0,\n  \"stream\": false,\n  \"presence_penalty\": 0,\n  \"frequency_penalty\": 1\n}")
            .asString();


}

