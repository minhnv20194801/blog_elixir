# Use the official Elixir image as the base
FROM elixir:latest

# Set the working directory
WORKDIR /app

# Copy the application files
COPY . .

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force
 
# Install dependencies
RUN mix deps.get

# # Check for clean code
RUN mix format --check-formatted
RUN mix credo
RUN mix dialyzer

ENV MIX_ENV=prod

# Release the application
RUN mix compile

RUN mix phx.digest

# Expose the application port
EXPOSE 4000

# Start the application
CMD ["mix", "phx.server"]