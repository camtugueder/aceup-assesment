# AceUp Tech Assessment - Backend

## Features
1. **Session Creation**: Users can create coaching sessions with a specific coach and client.
2. **Validation**: The application validates session data to prevent:
    - Overlapping sessions for a coach.
    - Sessions with a start time in the past.
    - Invalid data entries such as empty strings or missing fields.

## Technical Details

### Model
- **Session Model**: Represents a coaching session and includes fields such as `coach_hash_id`, `client_hash_id`, `start`, and `duration`.
- **Validations added**:
    - Presence and empty string validations for `coach_hash_id` and `client_hash_id`.
    - Custom validation to prevent overlapping sessions for a coach.
    - Custom validation to ensure the session `start` time is not in the past.

### Controller
- **SessionsController**: Handles the creation of sessions through the `create` action. Returns a 201 successful status when no error happened.
- **Error Handling**: Returns a 422 HTTP status when validation fails. Provides informative error messages for invalid requests.

### Routes
- Defined a resourceful route for sessions, currently supporting the `create` action.

### Database
- **Migrations**: Modified the `sessions` table with appropriate validations and indexes.
- **Constraints**: Database-level constraints for presence and data integrity.

## Installation and Setup
1. Clone the repository.
2. Navigate to the project directory.
3. Run `bundle install` to install the required gems.
4. Run `rails db:migrate` to set up the database.
5. Start the server with `rails s`.

## Usage
Send a POST request to `/sessions` with the following JSON structure:

```json
{
  "session": {
    "coach_hash_id": "<unique_coach_identifier>",
    "client_hash_id": "<unique_client_identifier>",
    "start": "<start_datetime>",
    "duration": <duration_in_minutes>
  }
}
```

## Testing
Tests are written using RSpec. FactoryBot gem was added to the project to use for creating test objects.To run the tests, execute the following command in your terminal:

```bash
bundle exec rspec
```


## Future Improvements
1. **Authentication and Authorization**: Implement user authentication and session-specific authorization to ensure data security and privacy.
2. **API Versioning**: Introduce versioning to the API to allow for backward compatibility and smoother transitions as new features are introduced.
3. **Advanced Scheduling Options**: Add support for recurring sessions, cancellations, and rescheduling.
4. **Notification System**: Implement a system to notify coaches and clients about upcoming sessions, changes, or cancellations.
5. **Performance Optimization**: Monitor and optimize performance as usage grows, potentially introducing caching or background job processing for heavy operations.
6. **User Interface**: Develop a user-friendly front end for easier management and scheduling of sessions.
